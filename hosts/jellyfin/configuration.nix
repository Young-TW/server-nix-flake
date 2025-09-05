{ config, pkgs, lib, ... }: {
  imports = [ ../common.nix ];

  networking.firewall.allowedTCPPorts = [ 8096 8920 ];
  networking.firewall.allowedUDPPorts = [ 1900 ];

  services.jellyfin.enable = true;

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
