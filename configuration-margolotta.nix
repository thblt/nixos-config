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

  imports =
    [
      ./hardware-configuration-margolotta.nix
      ./common.nix
    ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot = {
    # BitLocker doesn't support boot chaining.  This sets the
    # next-boot EFI variable to the Windows 11 loader and reboot when
    # Win11 is selected.
    extraInstallCommands = ''echo "reboot-for-bitlocker yes" >> /boot/loader/loader.conf'';
    # v Pending PR #253260 v
    # rebootForBitlocker = true;
    configurationLimit = 10;
  };

  # Nvidia
  graphics = {
    enable = true;
  };
  hardware  = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;
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

  boot.initrd.luks.devices = {
    crypt = {
      allowDiscards = true;
      preLVM = true;
    };
  };

  services.ddccontrol.enable = true;

  # Rainbow keyboard
  hardware.ckb-next.enable = true;
}
