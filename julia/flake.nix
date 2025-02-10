{
  description = "A Nix-flake-based Julia` development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          venvDir = ".venv";
          packages = with pkgs; [ python311 ] ++
            (with pkgs; [
              julia
            ]);
            shellHook = ''
              # Install packages from Project.toml if it exists
              #!/bin/bash
              if [ -e x.txt ]
              then
                printf "\n=== Project.toml detected! Installing packages.."
                julia --project=@. -e "import Pkg; Pkg.instantiate()"
              else
                printf "\n=== No Project.toml detected.\n"
              fi
              printf "\nDone! Enjoy your Julia shell.\n\n"
          '';
        };
      });
    };
}
