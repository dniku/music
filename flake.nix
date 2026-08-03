{
  description = "LilyPond workspace for multiple music tracks";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
      pkgsFor = system: import nixpkgs { inherit system; };

      repositoryRoot = ./.;
      tracksDirectory = ./tracks;
      artifactProvenanceSchema = ./artifact-provenance.schema.json;
      provenanceSidecars = lib.filter (path: lib.hasSuffix ".provenance.json" (toString path)) (
        lib.filesystem.listFilesRecursive repositoryRoot
      );
      provenanceSidecarPaths = map (
        path: lib.removePrefix "${toString repositoryRoot}/" (toString path)
      ) provenanceSidecars;
      trackIds = builtins.attrNames (
        lib.filterAttrs (_: kind: kind == "directory") (builtins.readDir tracksDirectory)
      );
      aliasCatalog = builtins.fromJSON (builtins.readFile ./aliases.json);
      tracks = lib.genAttrs trackIds (
        trackId:
        let
          metadataPath = tracksDirectory + "/${trackId}/reference/recordings.json";
        in
        {
          score = tracksDirectory + "/${trackId}/score.ly";
          inherit metadataPath;
        }
      );
      trackAliases =
        let
          aliases = builtins.attrNames aliasCatalog.aliases;
          aliasedTrackIds = builtins.attrValues aliasCatalog.aliases;
        in
        assert aliasCatalog.schemaVersion == 1;
        assert lib.all (alias: alias != "default" && !(builtins.elem alias trackIds)) aliases;
        assert lib.all (alias: builtins.match "^[a-z0-9]+(-+[a-z0-9]+)*$" alias != null) aliases;
        assert lib.all (trackId: builtins.elem trackId trackIds) aliasedTrackIds;
        aliasCatalog.aliases;

      scoreFor =
        system: trackId:
        let
          pkgs = pkgsFor system;
          track = tracks.${trackId};
        in
        pkgs.runCommand "${trackId}-score"
          {
            nativeBuildInputs = [ pkgs.lilypond ];
          }
          ''
            mkdir -p "$out"
            lilypond --output="$out/score" ${track.score}
            test -s "$out/score.pdf"
            test -s "$out/score.midi"
          '';

      metadataFor =
        system: trackId:
        let
          pkgs = pkgsFor system;
          track = tracks.${trackId};
        in
        pkgs.runCommand "${trackId}-metadata-check"
          {
            nativeBuildInputs = [ pkgs.jq ];
          }
          ''
            jq --exit-status \
              --arg track_id "${trackId}" '
              .schemaVersion == 1
              and .canonicalRecording.musicbrainz.recordingMbid == $track_id
              and ($track_id
                | test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"))
              and (.canonicalRecording.title | strings | length > 0)
              and (.canonicalRecording.artist | strings | length > 0)
              and (.assets | arrays)
              and ([.assets[] |
                (.path | strings | length > 0)
                and (.role | strings | length > 0)
                and (.durationSeconds | numbers | . > 0)
                and (.sha256 | strings | test("^[0-9a-f]{64}$"))
                and (.identity.status | strings | length > 0)
                and (.provenance.sidecarPath
                  | strings
                  | test("^audio/.+\\.provenance\\.json$"))
              ] | all)
            ' ${track.metadataPath} >/dev/null
            touch "$out"
          '';

      provenanceFor =
        system:
        let
          pkgs = pkgsFor system;
          sidecarManifest = pkgs.writeText "artifact-provenance-sidecars" (
            lib.concatStringsSep "\n" provenanceSidecarPaths
          );
        in
        pkgs.runCommand "artifact-provenance-sidecars-check"
          {
            nativeBuildInputs = [
              pkgs.check-jsonschema
              pkgs.coreutils
              pkgs.jq
            ];
            src = repositoryRoot;
          }
          ''
            sidecar_count=0
            while IFS= read -r relative_sidecar; do
              [[ -n "$relative_sidecar" ]] || continue
              sidecar="$src/$relative_sidecar"
              sidecar_count=$((sidecar_count + 1))
              check-jsonschema \
                --schemafile ${artifactProvenanceSchema} \
                "$sidecar"

              artifact_name="$(jq --raw-output '.artifact.path' "$sidecar")"
              expected_name="$artifact_name.provenance.json"
              actual_name="$(basename "$sidecar")"
              if [[ "$actual_name" != "$expected_name" ]]; then
                echo "Sidecar name mismatch: $sidecar" >&2
                echo "expected basename: $expected_name" >&2
                exit 1
              fi
            done < ${sidecarManifest}

            if (( sidecar_count == 0 )); then
              echo "No artifact provenance sidecars found" >&2
              exit 1
            fi
            touch "$out"
          '';

      scoresFor = system: lib.genAttrs trackIds (scoreFor system);

      allScoresFor =
        system:
        let
          pkgs = pkgsFor system;
          scores = scoresFor system;
        in
        pkgs.linkFarm "music-scores" (lib.mapAttrsToList (name: path: { inherit name path; }) scores);

      renderCommandsFor = trackId: ''
        track_build_directory="build/${trackId}"
        mkdir -p "$track_build_directory"
        rm --force -- \
          "$track_build_directory/score.pdf" \
          "$track_build_directory/score.midi" \
          "$track_build_directory/score.png" \
          "$track_build_directory"/score-page{1..99}.png
        lilypond \
          --output="$track_build_directory/score" \
          "tracks/${trackId}/score.ly"
        if (( $# > 0 )); then
          lilypond \
            "$@" \
            --output="$track_build_directory/score" \
            "tracks/${trackId}/score.ly"
        fi
      '';

      renderAppFor =
        system: applicationName: selectedTracks:
        let
          pkgs = pkgsFor system;
          application = pkgs.writeShellApplication {
            name = applicationName;
            runtimeInputs = [ pkgs.lilypond ];
            text = lib.concatMapStringsSep "\n" renderCommandsFor selectedTracks;
          };
        in
        {
          type = "app";
          program = "${application}/bin/${applicationName}";
          meta.description = "Render LilyPond scores into the local build directory";
        };

      renderTrackAppsFor =
        system:
        let
          canonicalApps = lib.listToAttrs (
            map (trackId: {
              name = "render-${trackId}";
              value = renderAppFor system "render-${trackId}" [ trackId ];
            }) trackIds
          );
          aliasApps = lib.mapAttrs' (
            alias: trackId:
            lib.nameValuePair "render-${alias}" (renderAppFor system "render-${alias}" [ trackId ])
          ) trackAliases;
        in
        canonicalApps // aliasApps;

      provenanceAppsFor =
        system:
        let
          pkgs = pkgsFor system;
          blownAwayTrackId = "e889154d-ae2d-43f0-bd2d-df87d068c0f3";
          blownAwaySourcePath = "tracks/${blownAwayTrackId}/reference/audio/youtube-nDxJJ_aEt2g.webm";
          blownAwaySourceSha256 = "e5c03bed98e78f063fadad2bb7cfb761a44c4d525b6a07a8b63141e9c9d92f30";
          blownAwaySoloPath = "build/${blownAwayTrackId}/solos/original-02m22.70-02m33.60.mp3";
          blownAwaySoloSha256 = "47abee71a626ce79ef1c25e148a8972c2d4fdd7682fc57d9dbd66116957c8709";
          volkiTrackId = "7402bbda-e0cf-4960-9b85-d8f6f4f85533";
          volkiSourcePath = "tracks/${volkiTrackId}/reference/audio/03. Волки Океана.mp3";
          volkiSourceSha256 = "37633b1684794052d0e1ca5ad333fd9aa2fc2cbb3fc0fa464110c42457429bbc";
          volkiEarlySoloPath = "build/${volkiTrackId}/solos/original-00m58.80-01m10.80.mp3";
          volkiEarlySoloSha256 = "3129d75f0863eb8771ec69e178d2639109d112ad09598febd59e34af9a3086f6";
          appFor =
            name: description: runtimeInputs: text:
            let
              application = pkgs.writeShellApplication {
                inherit name runtimeInputs text;
              };
            in
            {
              type = "app";
              program = "${application}/bin/${name}";
              meta.description = description;
            };
        in
        {
          verify-provenance =
            appFor "verify-provenance" "Validate provenance sidecars and their adjacent local audio artifacts"
              [
                pkgs.check-jsonschema
                pkgs.coreutils
                pkgs.ffmpeg
                pkgs.findutils
                pkgs.gawk
                pkgs.jq
              ]
              ''
                mapfile -d $'\0' sidecars < <(
                  find tracks build \
                    -type f \
                    -name '*.provenance.json' \
                    -print0 \
                    | sort --zero-terminated
                )

                if (( ''${#sidecars[@]} == 0 )); then
                  echo "No artifact provenance sidecars found" >&2
                  exit 1
                fi

                mapfile -d $'\0' audio_artifacts < <(
                  find tracks build \
                    -type f \
                    \( \
                      -name '*.mp3' \
                      -o -name '*.opus' \
                      -o -name '*.webm' \
                      -o -name '*.wav' \
                    \) \
                    -print0 \
                    | sort --zero-terminated
                )

                for artifact_path in "''${audio_artifacts[@]}"; do
                  sidecar="$artifact_path.provenance.json"
                  if [[ ! -f "$sidecar" ]]; then
                    echo "Missing provenance sidecar for $artifact_path" >&2
                    exit 1
                  fi
                done

                for sidecar in "''${sidecars[@]}"; do
                  check-jsonschema \
                    --schemafile ${artifactProvenanceSchema} \
                    "$sidecar"

                  artifact_name="$(jq --raw-output '.artifact.path' "$sidecar")"
                  artifact_path="$(dirname "$sidecar")/$artifact_name"
                  if [[ ! -f "$artifact_path" ]]; then
                    echo "Missing artifact for $sidecar: $artifact_path" >&2
                    exit 1
                  fi

                  expected_sha256="$(jq --raw-output '.artifact.sha256' "$sidecar")"
                  actual_sha256="$(sha256sum "$artifact_path" | cut --delimiter=' ' --fields=1)"
                  if [[ "$actual_sha256" != "$expected_sha256" ]]; then
                    echo "SHA-256 mismatch for $artifact_path" >&2
                    echo "expected: $expected_sha256" >&2
                    echo "actual:   $actual_sha256" >&2
                    exit 1
                  fi

                  expected_size="$(jq --raw-output '.artifact.sizeBytes' "$sidecar")"
                  actual_size="$(stat --format='%s' "$artifact_path")"
                  if [[ "$actual_size" != "$expected_size" ]]; then
                    echo "Size mismatch for $artifact_path" >&2
                    echo "expected: $expected_size" >&2
                    echo "actual:   $actual_size" >&2
                    exit 1
                  fi

                  expected_duration="$(jq --raw-output '.artifact.durationSeconds' "$sidecar")"
                  actual_duration="$(
                    ffprobe \
                      -v error \
                      -show_entries format=duration \
                      -of default=noprint_wrappers=1:nokey=1 \
                      "$artifact_path"
                  )"
                  if ! awk \
                    -v expected="$expected_duration" \
                    -v actual="$actual_duration" '
                      BEGIN {
                        difference = expected - actual
                        if (difference < 0) difference = -difference
                        exit difference > 0.002
                      }
                    '; then
                    echo "Duration mismatch for $artifact_path" >&2
                    echo "expected: $expected_duration" >&2
                    echo "actual:   $actual_duration" >&2
                    exit 1
                  fi
                done

                echo "Verified ''${#sidecars[@]} audio artifacts and provenance sidecars"
              '';

          fetch-blown-away-reference =
            appFor "fetch-blown-away-reference" "Fetch and verify the Blown Away YouTube audio reference"
              [
                pkgs.coreutils
                pkgs.yt-dlp
              ]
              ''
                output_path=${lib.escapeShellArg blownAwaySourcePath}
                expected_sha256=${lib.escapeShellArg blownAwaySourceSha256}

                mkdir -p "$(dirname "$output_path")"
                yt-dlp \
                  --no-playlist \
                  --format 251 \
                  --no-overwrites \
                  --output "$output_path" \
                  'https://www.youtube.com/watch?v=nDxJJ_aEt2g'

                actual_sha256="$(sha256sum "$output_path" | cut --delimiter=' ' --fields=1)"
                if [[ "$actual_sha256" != "$expected_sha256" ]]; then
                  echo "SHA-256 mismatch for $output_path" >&2
                  echo "expected: $expected_sha256" >&2
                  echo "actual:   $actual_sha256" >&2
                  exit 1
                fi
              '';

          extract-blown-away-solo =
            appFor "extract-blown-away-solo" "Extract and verify the original Blown Away solo audition clip"
              [
                pkgs.coreutils
                pkgs.ffmpeg
              ]
              ''
                input_path=${lib.escapeShellArg blownAwaySourcePath}
                expected_input_sha256=${lib.escapeShellArg blownAwaySourceSha256}
                output_path=${lib.escapeShellArg blownAwaySoloPath}
                expected_output_sha256=${lib.escapeShellArg blownAwaySoloSha256}
                temporary_output="''${output_path%.mp3}.tmp.mp3"

                actual_input_sha256="$(sha256sum "$input_path" | cut --delimiter=' ' --fields=1)"
                if [[ "$actual_input_sha256" != "$expected_input_sha256" ]]; then
                  echo "SHA-256 mismatch for $input_path" >&2
                  echo "expected: $expected_input_sha256" >&2
                  echo "actual:   $actual_input_sha256" >&2
                  exit 1
                fi

                mkdir -p "$(dirname "$output_path")"
                rm --force -- "$temporary_output"
                ffmpeg \
                  -nostdin \
                  -hide_banner \
                  -loglevel warning \
                  -i "$input_path" \
                  -ss 00:02:22.700 \
                  -t 00:00:10.900 \
                  -map 0:a:0 \
                  -vn \
                  -codec:a libmp3lame \
                  -q:a 2 \
                  -metadata 'title=Blown Away — original solo 2:22.70–2:33.60' \
                  -metadata 'source=https://www.youtube.com/watch?v=nDxJJ_aEt2g' \
                  -y \
                  "$temporary_output"

                actual_output_sha256="$(sha256sum "$temporary_output" | cut --delimiter=' ' --fields=1)"
                if [[ "$actual_output_sha256" != "$expected_output_sha256" ]]; then
                  echo "SHA-256 mismatch for generated solo" >&2
                  echo "expected: $expected_output_sha256" >&2
                  echo "actual:   $actual_output_sha256" >&2
                  rm --force -- "$temporary_output"
                  exit 1
                fi
                mv -- "$temporary_output" "$output_path"
              '';

          extract-volki-early-solo =
            appFor "extract-volki-early-solo" "Extract and verify the original Volki Okeana early solo clip"
              [
                pkgs.coreutils
                pkgs.ffmpeg
              ]
              ''
                input_path=${lib.escapeShellArg volkiSourcePath}
                expected_input_sha256=${lib.escapeShellArg volkiSourceSha256}
                output_path=${lib.escapeShellArg volkiEarlySoloPath}
                expected_output_sha256=${lib.escapeShellArg volkiEarlySoloSha256}
                temporary_output="''${output_path%.mp3}.tmp.mp3"

                actual_input_sha256="$(sha256sum "$input_path" | cut --delimiter=' ' --fields=1)"
                if [[ "$actual_input_sha256" != "$expected_input_sha256" ]]; then
                  echo "SHA-256 mismatch for $input_path" >&2
                  echo "expected: $expected_input_sha256" >&2
                  echo "actual:   $actual_input_sha256" >&2
                  exit 1
                fi

                mkdir -p "$(dirname "$output_path")"
                rm --force -- "$temporary_output"
                ffmpeg \
                  -nostdin \
                  -hide_banner \
                  -loglevel warning \
                  -i "$input_path" \
                  -ss 00:00:58.800 \
                  -t 00:00:12.000 \
                  -map 0:a:0 \
                  -vn \
                  -codec:a libmp3lame \
                  -q:a 2 \
                  -metadata 'title=Волки Океана — оригинальное раннее соло 0:58.80–1:10.80' \
                  -y \
                  "$temporary_output"

                actual_output_sha256="$(sha256sum "$temporary_output" | cut --delimiter=' ' --fields=1)"
                if [[ "$actual_output_sha256" != "$expected_output_sha256" ]]; then
                  echo "SHA-256 mismatch for generated early solo" >&2
                  echo "expected: $expected_output_sha256" >&2
                  echo "actual:   $actual_output_sha256" >&2
                  rm --force -- "$temporary_output"
                  exit 1
                fi
                mv -- "$temporary_output" "$output_path"
              '';
        };
    in
    {
      apps = forAllSystems (
        system:
        let
          renderAll = renderAppFor system "render-music" trackIds;
        in
        renderTrackAppsFor system
        // provenanceAppsFor system
        // {
          default = renderAll;
          render = renderAll;
        }
      );

      checks = forAllSystems (
        system:
        let
          scoreChecks = lib.listToAttrs (
            map (trackId: {
              name = "score-${trackId}";
              value = scoreFor system trackId;
            }) trackIds
          );
          metadataChecks = lib.listToAttrs (
            map (trackId: {
              name = "metadata-${trackId}";
              value = metadataFor system trackId;
            }) trackIds
          );
        in
        scoreChecks
        // metadataChecks
        // {
          provenance = provenanceFor system;
        }
      );

      formatter = forAllSystems (system: (pkgsFor system).nixfmt);

      packages = forAllSystems (
        system:
        let
          scores = scoresFor system;
          aliasScores = lib.mapAttrs (_: trackId: scores.${trackId}) trackAliases;
        in
        scores
        // aliasScores
        // {
          default = allScoresFor system;
        }
      );
    };
}
