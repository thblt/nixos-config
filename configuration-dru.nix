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

{ ... }:

{
  networking.hostName = "dru";

  imports = [ ./hardware-configuration-dru.nix ./common.nix ./packages.nix ];

  # TODO Find a way to move most of this to common.
  boot.initrd.luks.devices = {
    crypt = {
      device = "/dev/nvme0n1p2";
      allowDiscards = true;
      preLVM = true;
    };
  };

  powerManagement.powertop.enable = true;
  services.upower.enable = true;
}
