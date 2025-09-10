{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      nixpkgs,
      systems,
      ...
    }@inputs:
    let
      forEachSystem =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
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
      });

      packages = forEachSystem (pkgs: { });
    };
}
