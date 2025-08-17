{
  description = "Minecraft Server Flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.minecraft = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [

        ({ config, pkgs, ... }: {
          users.users.minecraft-server = {
            isSystemUser = true;
            group = "minecraft-server";
            home = "/var/lib/minecraft-server";
          };
          users.groups.minecraft-server = {};

          networking.firewall.allowedTCPPorts = [ 25565 ];

          systemd.services.minecraft-server = {
            description = "Minecraft Server";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];

            # if pkgs.papermc not exists, build will fail and need to be fixed.
            serviceConfig = {
              ExecStart = "${pkgs.papermc}/bin/minecraft-server -Xmx2G -Xms1G";
              WorkingDirectory = "/var/lib/minecraft-server";
              StateDirectory = "minecraft-server";
              User = "minecraft-server";
              Group = "minecraft-server";
              Restart = "always";
              RestartSec = "5s";
            };
          };
        })
      ];
    };

    devShells.${system}.default = let
      mkShell = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; };
    in mkShell {
      packages = with pkgs; [ nil ];
    };
  };
}
