# NixOS configuration for
#
# ▓█████▄  ██▀███   █    ██
# ▒██▀ ██▌▓██ ▒ ██▒ ██  ▓██▒
# ░██   █▌▓██ ░▄█ ▒▓██  ▒██░
# ░▓█▄   ▌▒██▀▀█▄  ▓▓█  ░██░
# ░▒████▓ ░██▓ ▒██▒▒▒█████▓
# ▒▒▓  ▒ ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒
# ░ ▒  ▒   ░▒ ░ ▒░░░▒░ ░ ░
# ░ ░  ░   ░░   ░  ░░░ ░ ░
#    ░       ░        ░

{ config, pkgs,  ... }:

{
  networking.hostName = "dru";

  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

    # Use the systemd-boot EFI boot loader.
    # TODO Find a way to move most of this to common.
    boot.initrd.luks.devices = {
      crypt = {
        device = "/dev/nvme0n1p2";
        allowDiscards = true;
        preLVM = true;
	    };
    };

    boot.kernelParams  = [ "acpi_rev_override=5" ];
    # hardware.bumblebee.enable = true;

    # Rainbow keyboard
    hardware.ckb-next.enable = true;
    }
