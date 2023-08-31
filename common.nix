# NixOS configuration bits I probably want in all my (desktop)
# machines.
#
# The computers this supports or has supported are:
#
# - Margalotta :: Desktop (i5-13600K + RTX4070)
# - Dru :: Thinkpad X270
# - Maladict :: XPS 15 9560
# - Wednesday :: (Some Asus gamer laptop I've had for a few weeks) [given away]
# - Anna :: MacbookAir 4,1   [retired]
# - Rudiger :: MacPro 3,1    [retired]

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
    # (import
    #   (builtins.fetchTarball
    #     https://github.com/nix-community/emacs-overlay/archive/master.tar.gz ))
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    extraModulePackages = [];
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "1"; # HiDPI
        memtest86.enable = true;
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

  # Talk with iOS hardware
  # services.usbmuxd.enable = true;

  # Keyboard and i18n
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr-bepo";
  services.xserver.layout = "fr";
  services.xserver.xkbVariant = "bepo";
  services.interception-tools = {
    enable = true;
    plugins = with pkgs.interception-tools-plugins; [ caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';


  };
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

  services.ddccontrol.enable = true;

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
  fonts.packages = let
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
  programs.steam.enable = true;

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
