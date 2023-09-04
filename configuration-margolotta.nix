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

{ pkgs, ... }:

{
  networking.hostName = "margolotta";

  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Nvidia
  hardware  = {
    nvidia = {
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      # forceFullCompositionPipeline = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
  programs.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    # Note to self: this value is of type lines, so it will merge
    # automatically with the default in common.nix.
    extraSessionCommands = ''
    export WLR_NO_HARDWARE_CURSORS=1
    '';
  };
  programs.hyprland.enable = true;
  boot.initrd.luks.devices = {
    crypt = {
      allowDiscards = true;
      preLVM = true;
    };
  };

  # Rainbow keyboard
  hardware.ckb-next.enable = true;
}
