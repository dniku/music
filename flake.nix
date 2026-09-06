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
      aliasTrackIds = builtins.attrNames aliasCatalog.tracks;
      tracks = lib.genAttrs trackIds (
        trackId:
        let
          directory = tracksDirectory + "/${trackId}";
          metadataPath = directory + "/reference/recordings.json";
          scoreDirectory = builtins.path {
            path = directory;
            name = "${trackId}-score-source";
            filter =
              path: type:
              path == toString directory
              || (
                type == "regular"
                && builtins.dirOf path == toString directory
                && (lib.hasSuffix ".ly" path || lib.hasSuffix ".ily" path)
              );
          };
        in
        {
          score = scoreDirectory + "/score.ly";
          inherit directory metadataPath scoreDirectory;
        }
      );
      trackAliases =
        let
          aliasPairs = lib.concatMap (
            trackId:
            let
              trackAliasConfig = aliasCatalog.tracks.${trackId};
            in
            map (alias: {
              name = alias;
              value = trackId;
            }) ([ trackAliasConfig.primaryAlias ] ++ trackAliasConfig.aliases)
          ) trackIds;
          aliases = map (aliasPair: aliasPair.name) aliasPairs;
          reservedAliases = [
            "artifacts"
            "default"
            "pdfs"
            "site"
          ];
        in
        assert aliasCatalog.schemaVersion == 3;
        assert lib.all (trackId: builtins.hasAttr trackId aliasCatalog.tracks) trackIds;
        assert lib.all (trackId: builtins.elem trackId trackIds) aliasTrackIds;
        assert builtins.length aliases == builtins.length (lib.unique aliases);
        assert lib.all (
          alias: !(builtins.elem alias reservedAliases) && !(builtins.elem alias trackIds)
        ) aliases;
        assert lib.all (alias: builtins.match "^[a-z0-9]+(-+[a-z0-9]+)*$" alias != null) aliases;
        lib.listToAttrs aliasPairs;

      primaryAliasesByTrackId = lib.genAttrs trackIds (
        trackId: aliasCatalog.tracks.${trackId}.primaryAlias
      );

      siteConfig = {
        title = "Музыкальные транскрипции";
        description = "Рабочие партитуры, партии и нотные разборы в PDF и MIDI.";
        repositoryUrl = "https://github.com/dniku/music";
      };

      siteTracks = lib.sort (left: right: builtins.lessThan left.sortKey right.sortKey) (
        map (
          trackId:
          let
            metadata = builtins.fromJSON (builtins.readFile tracks.${trackId}.metadataPath);
            recording = metadata.canonicalRecording;
          in
          {
            inherit trackId;
            alias = primaryAliasesByTrackId.${trackId};
            inherit (recording) artist title;
            releaseYear = recording.musicbrainz.releaseYear or null;
            sortKey = "${recording.artist} — ${recording.title}";
          }
        ) trackIds
      );

      scoreFor =
        system: trackId:
        let
          pkgs = pkgsFor system;
          track = tracks.${trackId};
        in
        pkgs.runCommand "${trackId}-score"
          {
            FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = [ pkgs.dejavu_fonts ]; };
            nativeBuildInputs = [
              pkgs.lilypond
              pkgs.qpdf
            ];
          }
          ''
            mkdir -p "$out"
            export XDG_CACHE_HOME="$TMPDIR/xdg-cache"
            mkdir -p "$XDG_CACHE_HOME/fontconfig"
            export SOURCE_DATE_EPOCH=946684800
            lilypond \
              --include=${track.scoreDirectory} \
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

      scoreBundleFor =
        system: name: extensions:
        let
          pkgs = pkgsFor system;
          scores = scoresFor system;
        in
        pkgs.runCommand name { } (
          ''
            mkdir -p "$out"
          ''
          + lib.concatMapStrings (
            trackId:
            let
              alias = primaryAliasesByTrackId.${trackId};
            in
            lib.concatMapStrings (extension: ''
              cp -- ${scores.${trackId}}/score.${extension} "$out/${alias}.${extension}"
            '') extensions
          ) trackIds
        );

      pdfBundleFor = system: scoreBundleFor system "music-score-pdfs" [ "pdf" ];

      artifactBundleFor =
        system:
        scoreBundleFor system "music-score-artifacts" [
          "midi"
          "pdf"
        ];

      siteTrackCardFor =
        track:
        let
          alias = lib.escapeXML track.alias;
          artist = lib.escapeXML track.artist;
          title = lib.escapeXML track.title;
          releaseDetails =
            (lib.optionalString (track.releaseYear != null) "${toString track.releaseYear} · ") + "PDF + MIDI";
          recordingUrl = "https://musicbrainz.org/recording/${track.trackId}";
          scoreUrl = "${siteConfig.repositoryUrl}/blob/main/tracks/${track.trackId}/score.ly";
        in
        ''
          <article class="score-card">
            <p class="score-card__artist">${artist}</p>
            <h3>${title}</h3>
            <p class="score-card__meta">${releaseDetails}</p>
            <div class="score-card__actions">
              <a class="button button--primary" href="scores/${alias}.pdf">Открыть PDF</a>
              <a class="button" href="scores/${alias}.midi" download>Скачать MIDI</a>
            </div>
            <p class="score-card__links">
              <a href="${recordingUrl}">MusicBrainz</a>
              <a href="${scoreUrl}">Исходник LilyPond</a>
            </p>
          </article>
        '';

      siteFor =
        system:
        let
          pkgs = pkgsFor system;
          artifacts = artifactBundleFor system;
          trackCount = builtins.length siteTracks;
          trackCards = lib.concatMapStringsSep "\n" siteTrackCardFor siteTracks;
          index = pkgs.writeText "index.html" (
            builtins.replaceStrings
              [
                "@@SITE_TITLE@@"
                "@@SITE_DESCRIPTION@@"
                "@@TRACK_COUNT@@"
                "@@TRACK_CARDS@@"
                "@@REPOSITORY_URL@@"
              ]
              [
                (lib.escapeXML siteConfig.title)
                (lib.escapeXML siteConfig.description)
                (toString trackCount)
                trackCards
                siteConfig.repositoryUrl
              ]
              (builtins.readFile ./site/index.html.in)
          );
        in
        pkgs.runCommand "music-pages"
          {
            nativeBuildInputs = [ pkgs.findutils ];
          }
          (
            ''
              mkdir -p "$out/scores"
              install --mode=0644 -- ${index} "$out/index.html"
              install --mode=0644 -- ${./site/styles.css} "$out/styles.css"
            ''
            + lib.concatMapStrings (track: ''
              install --mode=0644 -- \
                ${artifacts}/${track.alias}.pdf \
                "$out/scores/${track.alias}.pdf"
              install --mode=0644 -- \
                ${artifacts}/${track.alias}.midi \
                "$out/scores/${track.alias}.midi"
            '') siteTracks
            + ''
              test "$(grep --count 'class="score-card"' "$out/index.html")" -eq ${toString trackCount}
              test "$(find "$out/scores" -type f -name '*.pdf' | wc --lines)" -eq ${toString trackCount}
              test "$(find "$out/scores" -type f -name '*.midi' | wc --lines)" -eq ${toString trackCount}

              if find "$out" -type l -print -quit | grep --quiet .; then
                echo "Site output contains a symbolic link" >&2
                exit 1
              fi
              if find "$out" -type f -links +1 -print -quit | grep --quiet .; then
                echo "Site output contains a hard link" >&2
                exit 1
              fi
              if find "$out" -type f \
                \( -iname '*.mp3' -o -iname '*.opus' -o -iname '*.wav' -o -iname '*.webm' \) \
                -print -quit | grep --quiet .; then
                echo "Site output contains reference audio" >&2
                exit 1
              fi
            ''
          );

      renderCommandsFor =
        system: trackId:
        let
          buildAlias = primaryAliasesByTrackId.${trackId};
          score = (scoresFor system).${trackId};
        in
        ''
          track_build_directory="build/${buildAlias}"
          mkdir -p "$track_build_directory"
          install --mode=0644 -- \
            ${score}/score.pdf \
            "$track_build_directory/score.pdf"
          install --mode=0644 -- \
            ${score}/score.midi \
            "$track_build_directory/score.midi"

          if (( $# > 0 )); then
            preview_directory="$(
              mktemp \
                --directory \
                --tmpdir="$track_build_directory" \
                .score-preview.XXXXXX
            )"
            rm --force -- \
              "$track_build_directory/score.png" \
              "$track_build_directory"/score-page{1..99}.png
            if ! lilypond \
              "$@" \
              --output="$preview_directory/score" \
              "tracks/${trackId}/score.ly"; then
              rm --recursive --force -- "$preview_directory"
              exit 1
            fi

            while IFS= read -r -d "" preview_output; do
              preview_name="$(basename "$preview_output")"
              case "$preview_name" in
                score.pdf | score.midi) ;;
                *)
                  install --mode=0644 -- \
                    "$preview_output" \
                    "$track_build_directory/$preview_name"
                  ;;
              esac
            done < <(find "$preview_directory" -maxdepth 1 -type f -print0)
            rm --recursive --force -- "$preview_directory"
          fi
        '';

      renderAppFor =
        system: applicationName: selectedTracks:
        let
          pkgs = pkgsFor system;
          application = pkgs.writeShellApplication {
            name = applicationName;
            runtimeInputs = [
              pkgs.coreutils
              pkgs.findutils
              pkgs.lilypond
            ];
            text = lib.concatMapStringsSep "\n" (renderCommandsFor system) selectedTracks;
          };
        in
        {
          type = "app";
          program = "${application}/bin/${applicationName}";
          meta.description = "Export reproducible scores into the local build directory";
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
        scoreChecks
        // metadataChecks
        // {
          site = siteFor system;
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
          artifacts = artifactBundleFor system;
          default = allScoresFor system;
          pdfs = pdfBundleFor system;
          site = siteFor system;
        }
      );
    };
}
