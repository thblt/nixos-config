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

{ config, pkgs, ... }:

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
    # @FIXME vvv There's a default value in common.nix, try to extend rather than replace.
    extraSessionCommands = ''
    export MOZ_ENABLE_WAYLAND=1
    export WLR_NO_HARDWARE_CURSORS=1
    '';
  };

}

    boot.initrd.luks.devices = {
      crypt = {
        allowDiscards = true;
        preLVM = true;
      };
    };

    # Rainbow keyboard
    hardware.ckb-next.enable = true;
}
