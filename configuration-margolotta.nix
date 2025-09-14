# NixOS configuration for
#
#  ███▄ ▄███▓ ▄▄▄       ██▀███    ▄████  ▒█████   ██▓     ▒█████  ▄▄▄█████▓▄▄▄█████▓ ▄▄▄
# ▓██▒▀█▀ ██▒▒████▄    ▓██ ▒ ██▒ ██▒ ▀█▒▒██▒  ██▒▓██▒    ▒██▒  ██▒▓  ██▒ ▓▒▓  ██▒ ▓▒▒████▄
# ▓██    ▓██░▒██  ▀█▄  ▓██ ░▄█ ▒▒██░▄▄▄░▒██░  ██▒▒██░    ▒██░  ██▒▒ ▓██░ ▒░▒ ▓██░ ▒░▒██  ▀█▄
# ▒██    ▒██ ░██▄▄▄▄██ ▒██▀▀█▄  ░▓█  ██▓▒██   ██░▒██░    ▒██   ██░░ ▓██▓ ░ ░ ▓██▓ ░ ░██▄▄▄▄██
# ▒██▒   ░██▒ ▓█   ▓██▒░██▓ ▒██▒░▒▓███▀▒░ ████▓▒░░██████▒░ ████▓▒░  ▒██▒ ░   ▒██▒ ░  ▓█   ▓██▒
# ░ ▒░   ░  ░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░ ░▒   ▒ ░ ▒░▒░▒░ ░ ▒░▓  ░░ ▒░▒░▒░   ▒ ░░     ▒ ░░    ▒▒   ▓▒█░
# ░  ░      ░  ▒   ▒▒ ░  ░▒ ░ ▒░  ░   ░   ░ ▒ ▒░ ░ ░ ▒  ░  ░ ▒ ▒░     ░        ░      ▒   ▒▒ ░
# ░      ░     ░   ▒     ░░   ░ ░ ░   ░ ░ ░ ░ ▒    ░ ░   ░ ░ ░ ▒    ░        ░        ░   ▒
#        ░         ░  ░   ░           ░     ░ ░      ░  ░    ░ ░                          ░  ░

{ config, ... }:

{
  networking.hostName = "margolotta";

  imports = [
    ./hardware-configuration-margolotta.nix
    ./common.nix
    ./packages.nix
    ./home.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot = {
    rebootForBitlocker = true;
    configurationLimit = 10;
  };

  # Nvidia
  hardware = {
    graphics.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  programs.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    # Note to self: this value is of type lines, so it will merge
    # automatically with the default in common.nix.
    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';
  };

  boot.initrd.luks.devices = {
    crypt = {
      allowDiscards = true;
      preLVM = true;
    };
  };

  # Rainbow keyboard
  hardware.ckb-next.enable = true;

  system.stateVersion = "24.05";
  home-manager.users.thblt.home.stateVersion = "25.11";
}
