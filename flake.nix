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
              and (.assets | arrays | length > 0)
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
    in
    {
      apps = forAllSystems (
        system:
        let
          renderAll = renderAppFor system "render-music" trackIds;
        in
        renderTrackAppsFor system
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
