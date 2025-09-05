{ config, pkgs, ... }: {
  imports = [ ../common.nix ];

  networking.firewall.allowedTCPPorts = [ 8096 8920 ];
  networking.firewall.allowedUDPPorts = [ 1900 ];

  services.jellyfin.enable = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
