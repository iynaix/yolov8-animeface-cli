{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, system, ... }:
        let
          anime-face-model = pkgs.fetchurl {
            url = "https://github.com/Fuyucch1/yolov8_animeface/releases/download/v1/yolov8x6_animeface.pt";
            hash = "sha256-883BpiZjRzIkOf2bPI9aEiJmjrEMit8A4XsoxIuVITw=";
          };
          rocmPkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              rocmSupport = true;
              allowUnfree = true;
            };
          };
          cudaPkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              cudaSupport = true;
              allowUnfree = true;
            };
          };
          mkDevShell =
            pkgs:
            pkgs.mkShell {
              env = {
                MODEL_PATH = toString anime-face-model;
              };
              packages = with pkgs; [
                (python3.withPackages (
                  ps: with ps; [
                    ultralytics
                  ]
                ))
                python3Packages.flake8
                python3Packages.black
              ];
            };
        in
        {
          devShells = {
            default = mkDevShell pkgs;
            cuda = mkDevShell cudaPkgs;
            rocm = mkDevShell rocmPkgs;
          };

          packages = rec {
            default = pkgs.callPackage ./package.nix { inherit anime-face-model; };
            inherit anime-face-model;
            anime-face-detector = default;
            anime-face-detector-cuda = cudaPkgs.callPackage ./package.nix {
              inherit anime-face-model;
              cudaSupport = true;
            };
            anime-face-detector-rocm = rocmPkgs.callPackage ./package.nix {
              inherit anime-face-model;
              rocmSupport = true;
            };
          };
        };
    };
}
