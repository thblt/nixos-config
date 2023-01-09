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

  nixpkgs.overlays = [
    # Mozilla
    (import
      (builtins.fetchTarball
        https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz ))
    # Emacs
    (import
      (builtins.fetchTarball
        https://github.com/nix-community/emacs-overlay/archive/master.tar.gz ))
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    extraModulePackages = [];
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

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # @FIXME This breaks optirun
  powerManagement.powertop.enable = true;

  # Talk with iOS hardware
  # services.usbmuxd.enable = true;

  # i18n
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr-bepo";
  services.xserver.layout = "fr";
  services.xserver.xkbVariant = "bepo";

  # greetd

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
      };
    };
  };

  # Time
  time.timeZone = "Europe/Paris";
  time.hardwareClockInLocalTime = true;

  programs = {
    command-not-found.enable = true;
    file-roller.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    light.enable = true;
    ssh.startAgent = false;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      '';
      extraPackages = with pkgs; [
        alacritty
        fuzzel
        grim
        sway-contrib.grimshot
        libnotify
        mako
        swayidle
        swaylock
        udiskie
        waybar
        wl-clipboard
        (import ./packages/wl-ime-type.nix)
        # xwayland.
        xdg-utils
        xorg.xev
        xsel
        xwayland
      ];
    };
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
      samsung-unified-linux-driver
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
    pkgs.libertine
    pkgs.open-sans
    pkgs.symbola
  ];

  services.keybase.enable = true;
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
  services.pcscd.enable = true;   # Smartcard support
  programs.gnupg.agent.pinentryFlavor = "gtk2";

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

  services.udisks2.enable = true;

  virtualisation.virtualbox.host.enable = true;
  #services.postgresql.enable = true;

  system.stateVersion = "18.03";
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  # android_sdk.accept_license = true;
}
