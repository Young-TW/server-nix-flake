{
  description = "NixOS configuration for server deployment";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    disko.url       = "github:nix-community/disko";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.hello;
      }
    ) // {
      nixosConfigurations.forgejo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/forgejo/configuration.nix ];
        specialArgs = { disko = inputs.disko; };
      };

      nixosConfigurations.caddy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/caddy/configuration.nix ];
        specialArgs = { disko = inputs.disko; };
      };

      nixosConfigurations.minecraft = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/minecraft/configuration.nix ];
        specialArgs = { disko = inputs.disko; };
      };
    };
}
