{
  description = "NixOS configuration for server deployment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages.default = pkgs.hello;
      }
    ) // {
      nixosConfigurations.forgejo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/forgejo/configuration.nix
        ];
      };
      nixosConfigurations.caddy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/caddy/configuration.nix
        ];
      };
      nixosConfigurations.minecraft = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/minecraft/configuration.nix
        ];
      };
    };
}
