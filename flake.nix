{
  description = "irishgreencitrus' custom nixpkgs repository";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  } @ inputs: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    packages = forAllSystems (
      system:
        import ./default.nix {
          pkgs = import nixpkgs {
            inherit system;
          };
        }
    );
  };
}
