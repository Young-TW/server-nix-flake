{ config, pkgs, lib, ... }:
{
  # 若這台有對應的硬體檔，記得引入
  # imports = [ ./hardware-configuration.nix ];

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
      # 依實際可執行檔名調整（可能是 papermc / paper 等）
      ExecStart = "${pkgs.papermc}/bin/minecraft-server -Xmx2G -Xms1G";
      WorkingDirectory = "/var/lib/minecraft-server";
      StateDirectory = "minecraft-server";
      User = "minecraft-server";
      Group = "minecraft-server";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  system.stateVersion = "24.05"; # 依你的系統版本調整
}
