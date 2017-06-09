{ config, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    "/etc/nixos/roles/desktop.nix"
    "/etc/nixos/class/laptop.nix"
  ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "wednesday";

  services.xserver.videoDrivers = [ "i915" "i965" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/db15ad48-c4a4-4f24-be6e-9648da1ee563";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "powersave";
}
