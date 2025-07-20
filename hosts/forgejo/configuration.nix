{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # 請依你 VM 磁碟實際裝置修改（如 /dev/sda）

  networking.hostName = "forgejo";

  time.timeZone = "Asia/Taipei";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
    tmux
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  system.stateVersion = "24.05";
}
