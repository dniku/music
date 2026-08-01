{
  description = "LilyPond lyric sheet for Atom-76 — Volki Okeana";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: import nixpkgs { inherit system; };
      scoreFor =
        system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.runCommand "volki-okeana-score"
          {
            nativeBuildInputs = [ pkgs.lilypond ];
          }
          ''
            mkdir -p "$out"
            lilypond --output="$out/volki-okeana" ${./score/volki-okeana.ly}
            test -s "$out/volki-okeana.pdf"
            test -s "$out/volki-okeana.midi"
          '';
      metadataFor =
        system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.runCommand "volki-okeana-metadata-check"
          {
            nativeBuildInputs = [ pkgs.jq ];
          }
          ''
            jq --exit-status '
              .schemaVersion == 1
              and (.canonicalRecording.musicbrainz.recordingMbid
                | test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"))
              and (.assets | length == 2)
              and ([.assets[].sha256 | test("^[0-9a-f]{64}$")] | all)
              and ([.assets[].identity.status] | sort == ["matched", "unmatched_variant"])
            ' ${./reference/recordings.json} >/dev/null
            touch "$out"
          '';
      renderAppFor =
        system:
        let
          pkgs = pkgsFor system;
          app = pkgs.writeShellApplication {
            name = "render-volki-okeana";
            runtimeInputs = [ pkgs.lilypond ];
            text = ''
              mkdir -p build
              rm --force -- \
                build/volki-okeana.pdf \
                build/volki-okeana.midi \
                build/volki-okeana.png \
                build/volki-okeana-page{1..99}.png
              lilypond --output=build/volki-okeana score/volki-okeana.ly
              if (( $# > 0 )); then
                lilypond "$@" --output=build/volki-okeana score/volki-okeana.ly
              fi
            '';
          };
        in
        {
          type = "app";
          program = "${app}/bin/render-volki-okeana";
          meta.description = "Render the Volki Okeana lyric sheet with LilyPond";
        };
    in
    {
      apps = forAllSystems (system: {
        default = renderAppFor system;
        render = renderAppFor system;
      });

      checks = forAllSystems (system: {
        metadata = metadataFor system;
        score = scoreFor system;
      });

      formatter = forAllSystems (system: (pkgsFor system).nixfmt);

      packages = forAllSystems (system: {
        default = scoreFor system;
        score = scoreFor system;
      });
    };
}
