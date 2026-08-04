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

      tracksDirectory = ./tracks;
      trackIds = builtins.attrNames (
        lib.filterAttrs (_: kind: kind == "directory") (builtins.readDir tracksDirectory)
      );
      aliasCatalog = builtins.fromJSON (builtins.readFile ./aliases.json);
      tracks = lib.genAttrs trackIds (
        trackId:
        let
          directory = tracksDirectory + "/${trackId}";
          metadataPath = directory + "/reference/recordings.json";
        in
        {
          score = directory + "/score.ly";
          inherit directory metadataPath;
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
            nativeBuildInputs = [
              pkgs.lilypond
              pkgs.qpdf
            ];
          }
          ''
            mkdir -p "$out"
            export SOURCE_DATE_EPOCH=946684800
            lilypond \
              --include=${track.directory} \
              --output="$out/score" \
              ${track.score}
            qpdf \
              --empty \
              --pages "$out/score.pdf" 1-z \
              -- \
              --remove-info \
              --remove-metadata \
              --static-id \
              "$out/score.normalized.pdf"
            mv -- "$out/score.normalized.pdf" "$out/score.pdf"
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
              .schemaVersion == 2
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
              ] | all)
            ' ${track.metadataPath} >/dev/null
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
        export SOURCE_DATE_EPOCH=946684800
        rm --force -- \
          "$track_build_directory/score.pdf" \
          "$track_build_directory/score.midi" \
          "$track_build_directory/score.png" \
          "$track_build_directory"/score-page{1..99}.png
        lilypond \
          --output="$track_build_directory/score" \
          "tracks/${trackId}/score.ly"
        qpdf \
          --empty \
          --pages "$track_build_directory/score.pdf" 1-z \
          -- \
          --remove-info \
          --remove-metadata \
          --static-id \
          "$track_build_directory/score.normalized.pdf"
        mv -- \
          "$track_build_directory/score.normalized.pdf" \
          "$track_build_directory/score.pdf"
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
            runtimeInputs = [
              pkgs.lilypond
              pkgs.qpdf
            ];
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

      artifactAppsFor =
        system:
        let
          pkgs = pkgsFor system;
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
          scriptAppFor =
            name: description: runtimeInputs: script:
            appFor name description runtimeInputs (builtins.readFile script);
        in
        {
          dvc = {
            type = "app";
            program = lib.getExe pkgs.dvc;
            meta.description = "Run the pinned DVC command-line client";
          };

          verify-references =
            appFor "verify-references" "Validate reference audio against recordings.json"
              [
                pkgs.coreutils
                pkgs.ffmpeg
                pkgs.findutils
                pkgs.gawk
                pkgs.jq
              ]
              ''
                mapfile -d $'\0' metadata_files < <(
                  find tracks \
                    -type f \
                    -path '*/reference/recordings.json' \
                    -print0 \
                    | sort --zero-terminated
                )

                if (( ''${#metadata_files[@]} == 0 )); then
                  echo "No recording metadata found" >&2
                  exit 1
                fi

                reference_count=0
                for metadata_file in "''${metadata_files[@]}"; do
                  reference_directory="$(dirname "$metadata_file")"
                  while IFS= read -r asset; do
                    relative_path="$(jq --raw-output '.path' <<<"$asset")"
                    artifact_path="$reference_directory/$relative_path"
                    reference_count=$((reference_count + 1))

                    if [[ ! -f "$artifact_path" ]]; then
                      echo "Missing reference artifact: $artifact_path" >&2
                      exit 1
                    fi

                    expected_sha256="$(jq --raw-output '.sha256' <<<"$asset")"
                    actual_sha256="$(sha256sum "$artifact_path" | cut --delimiter=' ' --fields=1)"
                    if [[ "$actual_sha256" != "$expected_sha256" ]]; then
                      echo "SHA-256 mismatch for $artifact_path" >&2
                      echo "expected: $expected_sha256" >&2
                      echo "actual:   $actual_sha256" >&2
                      exit 1
                    fi

                    expected_duration="$(jq --raw-output '.durationSeconds' <<<"$asset")"
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
                  done < <(jq --compact-output '.assets[]' "$metadata_file")
                done

                echo "Verified $reference_count reference audio artifacts"
              '';

          fetch-youtube-audio =
            scriptAppFor "fetch-youtube-audio" "Fetch and SHA-256 verify a YouTube audio stream"
              [
                pkgs.coreutils
                pkgs.yt-dlp
              ]
              ./scripts/fetch-youtube-audio;

          extract-audio = scriptAppFor "extract-audio" "Extract an exact audio range with FFmpeg" [
            pkgs.coreutils
            pkgs.ffmpeg
          ] ./scripts/extract-audio;

          render-audition = scriptAppFor "render-audition" "Render a LilyPond audition to PDF and MP3" [
            pkgs.coreutils
            pkgs.ffmpeg
            pkgs.lilypond
            pkgs.qpdf
            pkgs.timidity
          ] ./scripts/render-audition;

          render-midi-audition = scriptAppFor "render-midi-audition" "Render a MIDI file to an MP3 audition" [
            pkgs.coreutils
            pkgs.ffmpeg
            pkgs.timidity
          ] ./scripts/render-midi-audition;

          stereo-compare =
            scriptAppFor "stereo-compare" "Place two audio files in the left and right channels"
              [
                pkgs.coreutils
                pkgs.ffmpeg
              ]
              ./scripts/stereo-compare;

          slow-audio = scriptAppFor "slow-audio" "Change audio tempo while preserving pitch" [
            pkgs.coreutils
            pkgs.ffmpeg
          ] ./scripts/slow-audio;
        };
    in
    {
      apps = forAllSystems (
        system:
        let
          renderAll = renderAppFor system "render-music" trackIds;
        in
        renderTrackAppsFor system
        // artifactAppsFor system
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
        scoreChecks // metadataChecks
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
