# NixOS configuration for
#               _           _ _      _
#   /\/\   __ _| | __ _  __| (_) ___| |_
#  /    \ / _` | |/ _` |/ _` | |/ __| __|
# / /\/\ \ (_| | | (_| | (_| | | (__| |_
# \/    \/\__,_|_|\__,_|\__,_|_|\___|\__|
#

{ config, pkgs,  ... }:

{
  networking.hostName = "maladict";

  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

    console.font = pkgs.lib.mkForce "${pkgs.terminus_font}/share/consolefonts/ter-i32n.psf.gz"; # HiDPI console

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
