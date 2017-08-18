{ config, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    "/etc/nixos/roles/desktop.nix"
    "/etc/nixos/class/laptop.nix"
    "/etc/nixos/class/hidpi.nix"    
  ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "maladict";

  services.xserver.videoDrivers = [ "i915" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices.crypted.device = "/dev/nvme0n1p2";

  fileSystems."/" =
    { device = "/dev/mapper/VolGroup-NixRoot";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/mapper/VolGroup-Home";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/250E-355D";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = "powersave";
}
