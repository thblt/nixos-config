# NixOS configuration bits I probably want in all my machines.
#
# The computers this supports or has supported are:
#
# - Rudiger :: MacPro 3,1    [retired]
# - Anna :: MacbookAir 4,1   [retired]
# - Wednesday :: (Some Asus gamer laptop I've had for a few weeks) [given away]
# - Maladict :: XPS 15 9560
# - Dru :: Lenovo Thinkpad X270

{ config, pkgs,  ... }:

{
  imports =
    [
      ./packages.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "1"; # HiDPI
      };
      timeout = 30;
      efi.canTouchEfiVariables = true;
    };
  };

  # Update the microcode
  hardware.cpu.intel.updateMicrocode = true;

  # TRIM
  services.fstrim.enable = true;

  # Video
  boot.kernelParams  = [ "acpi_rev_override=5" ];
  # hardware.bumblebee.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # @FIXME This breaks optirun
  powerManagement.powertop.enable = true;

  # Talk with iOS hardware
  # services.usbmuxd.enable = true;

  # i18n
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr-bepo";

  # Time
  time.timeZone = "Europe/Paris";
  time.hardwareClockInLocalTime = true;

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        alacritty
        dmenu
        grim
        libnotify
        mako
        rofi
        swayidle
        swaylock
        udiskie
        waybar
        wl-clipboard
        xorg.xev
        xsel
        xwayland
      ];
    };
    light.enable = true;
    command-not-found.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ssh.startAgent = false;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
    };
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

  fonts.fontDir.enable = true;
  fonts.fonts = let
    iosevkaTerm = pkgs.iosevka.override {
      set = "thblt";
      privateBuildPlan = {
        family = "Iosevka";
        design = [ "term"  ];
      };
    };
    # Note to self: `slab` isn't distinct enough from `sans` for the
    # two to be used together.
  in [
    # iosevkaTerm
    pkgs.iosevka
    pkgs.open-sans
    pkgs.symbola
  ];

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

  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "18.03";
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
}
