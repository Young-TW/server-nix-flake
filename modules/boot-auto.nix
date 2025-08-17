# Auto-select bootloader (UEFI: systemd-boot, BIOS: GRUB)
{ lib, config, ... }:
let
  inherit (lib) mkIf mkMerge;
  isEFI = builtins.pathExists "/sys/firmware/efi";
in
{
  options.boot.auto.bootDisk = lib.mkOption {
    type = lib.types.str;
    default = "/dev/vda";  # BIOS 模式下寫入 MBR 的「整顆磁碟」
    description = "Target disk for GRUB MBR when booting in BIOS mode.";
  };

  config = mkMerge [
    # UEFI：systemd-boot（ESP 預設掛 /boot；若你掛 /boot/efi，解註下一行）
    (mkIf isEFI {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      # boot.loader.efi.efiSysMountPoint = "/boot/efi";
      boot.loader.grub.enable = false;
    })

    # Legacy BIOS：GRUB 安裝到整顆磁碟的 MBR
    (mkIf (!isEFI) {
      boot.loader.systemd-boot.enable = false;
      boot.loader.grub.enable = true;
      boot.loader.grub.devices = [ config.boot.auto.bootDisk ];
    })
  ];
}
