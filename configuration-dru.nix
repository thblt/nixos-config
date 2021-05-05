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

  # TODO Find a way to move most of this to common.
  boot.initrd.luks.devices = {
    crypt = {
      device = "/dev/nvme0n1p2";
      allowDiscards = true;
      preLVM = true;
	  };
  };
}
