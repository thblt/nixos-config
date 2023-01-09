# NixOS configuration for
#
#   ███▄ ▄███▓ ▄▄▄       ██▓    ▄▄▄      ▓█████▄  ██▓ ▄████▄  ▄▄▄█████▓
#  ▓██▒▀█▀ ██▒▒████▄    ▓██▒   ▒████▄    ▒██▀ ██▌▓██▒▒██▀ ▀█  ▓  ██▒ ▓▒
#  ▓██    ▓██░▒██  ▀█▄  ▒██░   ▒██  ▀█▄  ░██   █▌▒██▒▒▓█    ▄ ▒ ▓██░ ▒░
#  ▒██    ▒██ ░██▄▄▄▄██ ▒██░   ░██▄▄▄▄██ ░▓█▄   ▌░██░▒▓▓▄ ▄██▒░ ▓██▓ ░
#  ▒██▒   ░██▒ ▓█   ▓██▒░██████▒▓█   ▓██▒░▒████▓ ░██░▒ ▓███▀ ░  ▒██▒ ░
#  ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒░▓  ░▒▒   ▓▒█░ ▒▒▓  ▒ ░▓  ░ ░▒ ▒  ░  ▒ ░░
#  ░  ░      ░  ▒   ▒▒ ░░ ░ ▒  ░ ▒   ▒▒ ░ ░ ▒  ▒  ▒ ░  ░  ▒       ░
#  ░      ░     ░   ▒     ░ ░    ░   ▒    ░ ░  ░  ▒ ░░          ░
#         ░         ░  ░    ░  ░     ░  ░   ░     ░  ░ ░

{ config, pkgs, ... }:

{
  networking.hostName = "maladict";

  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

  powerManagement.powertop.enable = pkgs.lib.mkForce false;

  # console.font = pkgs.lib.mkForce "${pkgs.terminus_font}/share/consolefonts/ter-i32n.psf.gz"; # HiDPI console
  hardware.video.hidpi.enable = true;

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

  # Rainbow keyboard
  hardware.ckb-next.enable = true;
}
