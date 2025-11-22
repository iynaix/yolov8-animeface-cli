{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        let
          anime-face-model = pkgs.fetchurl {
            url = "https://github.com/Fuyucch1/yolov8_animeface/releases/download/v1/yolov8x6_animeface.pt";
            hash = "sha256-883BpiZjRzIkOf2bPI9aEiJmjrEMit8A4XsoxIuVITw=";
          };
        in
        {
          devShells = {
            default = pkgs.mkShell {
              env = {
                MODEL_PATH = toString anime-face-model;
              };
              packages = with pkgs; [
                (pkgs.python3.withPackages (
                  ps: with ps; [
                    ultralytics
                  ]
                ))
                python3Packages.flake8
                python3Packages.black
              ];
            };
          };

          packages = rec {
            default = pkgs.callPackage ./package.nix { inherit anime-face-model; };
            inherit anime-face-model;
            anime-face-detector = default;
            anime-face-detector-cuda = default.override { cudaSupport = true; };
            anime-face-detector-rocm = default.override { rocmSupport = true; };
          };
        };
    };
}
