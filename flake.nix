{
  description = "My phomelab configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      
      perSystem = { pkgs, system, ... }:
        let
          packages = import ./pkgs {
            inherit pkgs system;
          };

          ansible = pkgs.python3Packages.toPythonApplication (
            pkgs.python3Packages.ansible-core.override {
              extraPackages = _: [ packages.mitogen ];
            }
          );
        in {
          packages = packages;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              ansible
              just
              parallel
            ];

            shellHook = ''
              export ANSIBLE_STRATEGY_PLUGINS="${packages.mitogen}/${pkgs.python3.sitePackages}/ansible_mitogen/plugins/strategy"
              export ANSIBLE_STRATEGY=mitogen_linear
              ansible --version
            '';
          };
        };
    };
}
