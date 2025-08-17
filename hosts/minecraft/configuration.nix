{ config, pkgs, lib, ... }:
{
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

    serviceConfig = {
      ExecStart = "${pkgs.papermc}/bin/minecraft-server -Xmx2G -Xms1G";
      WorkingDirectory = "/var/lib/minecraft-server";
      StateDirectory = "minecraft-server"; # auto-create /var/lib/minecraft-server
      User = "minecraft-server";
      Group = "minecraft-server";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  system.stateVersion = "24.05";
}
