# NixOS configuration for
#               _           _ _      _
#   /\/\   __ _| | __ _  __| (_) ___| |_
#  /    \ / _` | |/ _` |/ _` | |/ __| __|
# / /\/\ \ (_| | | (_| | (_| | | (__| |_
# \/    \/\__,_|_|\__,_|\__,_|_|\___|\__|
#

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./bepo-afnor.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
      loader = {
        systemd-boot = {
          # grub = {
            enable = true;
            editor = false;
            consoleMode = "1"; # HiDPI
        };
        timeout = 30;
        efi.canTouchEfiVariables = true;
      };
      # earlyVconsoleSetup = true; # HiDPI
      initrd.luks.devices = {
        crypted = {
          device = "/dev/nvme0n1p2";
          allowDiscards = true;
          preLVM = true;
	      };
      };
      # kernelPackages = pkgs.linuxPackages_latest;
    };

    # Update the microcode
    hardware.cpu.intel.updateMicrocode = true;

    # TRIM
    services.fstrim.enable = true;

    # Video
    boot.kernelParams  = [ "acpi_rev_override=5" ];
    hardware.bumblebee.enable = true;

    # Sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Networking
    networking.hostName = "maladict";
    networking.networkmanager.enable = true;

    # Rainbow keyboard
    hardware.ckb-next.enable = true;

    # @FIXME This breaks optirun
    powerManagement.powertop.enable = true;

    # Talk with iOS hardware
    services.usbmuxd.enable = true;

    # i18n
    i18n.defaultLocale = "fr_FR.UTF-8";
    console.font = pkgs.lib.mkForce "${pkgs.terminus_font}/share/consolefonts/ter-i32n.psf.gz"; # HiDPI
    console.keyMap = "fr-bepo";

    # Time
    time.timeZone = "Europe/Paris";
    time.hardwareClockInLocalTime = true;

    programs = {
      sway.enable = true;
      light.enable = true;
      # way-cooler.enable = true;
      command-not-found.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      ssh.startAgent = false;
      zsh.enable = true;
    };

    # Printing
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        samsungUnifiedLinuxDriver
        brgenml1cupswrapper
      ];
    };

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };

    # Base system programs
    environment.systemPackages = with pkgs; [
      file
      pciutils
      psmisc
      emacs
      powertop
      acpi

      ifuse
      libimobiledevice
      ideviceinstaller
    ];

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      #desktopManager.gnome3.enable = true;
      # dpi = 289; # HiDPI
      layout = "fr";
      xkbVariant = "bepo";
      xkbOptions = "caps:ctrl_modifier";
      libinput = {
        enable = true;
        disableWhileTyping = true;
      };
      displayManager.gdm.enable = false;
      displayManager.lightdm = {
        enable = true;
        greeters.gtk.indicators = [ "~host" "~spacer" "~clock" "~spacer" "~session" "~language" "~a11y" "~power" ];
        autoLogin = {
          enable = true;
          user = "thblt";
        };
      };
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
    fonts.fontconfig.dpi = 289; # HiDPI

    services.gnome3.gnome-keyring.enable = pkgs.lib.mkForce false;

    users = {
      defaultUserShell = pkgs.zsh;
      extraUsers.thblt = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "sway"
          "video" # For programs.light to work
          "wheel" ];
          uid = 1000;
      };
    };

    # Smartcard support
    services.pcscd.enable = true;
    hardware.u2f.enable = true;

    virtualisation.virtualbox.host.enable = true;

    system.stateVersion = "18.03";
    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;
}
