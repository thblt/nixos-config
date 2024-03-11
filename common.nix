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
        "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz" ))
    # Emacs
    # (import
    #   (builtins.fetchTarball
    #     "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz" ))
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    extraModulePackages = [];
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
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
  programs.kdeconnect.enable = true;

  # @FIXME This breaks optirun

  # Talk with iOS hardware
  # services.usbmuxd.enable = true;

  # Keyboard and i18n
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr-bepo";
  services.xserver.xkb= {
    layout = "fr";
    variant = "bepo";
  };
  services.interception-tools = {
    # Disabled, because the capslock ctrl/esc dual function key breaks
    # ctrl-click.
    enable = false;
    plugins = with pkgs.interception-tools-plugins; [ caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # Funny inputs
  hardware = {
    keyboard.qmk.enable = true;
    spacenavd.enable = true;
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

  services.keybase.enable = false;
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
      openssh.authorizedKeys.keys = [
        # card# at the end of each line.
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDde2MPB00fVbWAEUviB5hnHAhFnY7nVl3Zxu/++XZF4fy161dAMWZDV8oeHc06g6Ty907R0JCRSLDU1fP1J8FGlXTl0gWkeic4t14tZ4C4Pij1pA2q/4+z3WEeQjwD9nGEIUK8bdnVaocMWxxH24LjAFYNYac2tAC8XmKyDwXwqqsq8Tg6htAoO/7sPyoxv+NTeVZqDd+Y5yK3bnEAptApY6ErzIwwAhgONGxbxn0w/SXs3YKogTukEtUuDYwGa8M9bMwTlY8cpXsvk0J/ddofDZj0jRZLetTFCz5p7PzZyE7hF73kH6/PXw3rOOBaryPwObYB6wNh3XR2j58yqr3+oaRgIPm7p5nL1P/GAP9b4q8XkGBNfoMyjgUuHVXzzWvJDfiqGwWxFc9bjIWJTT/d8l29HorV3IYxRtB8xBg5bvG2/A5XJHnq5z8Z6sm/DCe2t84q4zk4vVDDWLqO0hfIKj4VQy9Gmj/cBxLnDsswXlx76wt8hS74wj6W0MjC34oVspc7GtSu3lXvTJtLf942QTvBR4Xl0c+lzsbRg8mEtaWqcluAlKFCpZqpOa1s8JDPtyHbzAUYHu+Ik7rsLsJsw+c3vdySeXxCRM8v/fd79TSMLpXboM7m53BIMYI+N4N+7subvicv3SOvtNzpssWFdxOrPI9TkPBpQVrop83/GQ== cardno:15 470 645"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9w74+o0BkC7hDWMc7GBGnFjx3gJxQ6DWIDsriavYzOzVnHM/WBXStqGBSO49hlXppWXzCrWTopLWk3t9jwq08Jai0msS4k/I1MpyePj24Z4fFtm/XstI17JCCiaMgjphoXPLAd4tJstSn00w5ZyCdF6LeZt5hWAKdP4cRntnUtlnFIeIS9VW1bNNoHbM1ZKF6q1uhT8bsHIzwlgqnA6ychDXrJEs2YYwh+4RgZtkDzjvdcdWGduoFSUS+dbeBoYlpI2fTvM9ukIqIrZlUT27+6napUKEWYDPen7mi6ZxEURMFup39WEiOI+xaXUlLjAn+nivwuhAOEh3xOh7dEzK+ds4MvMM5WXhTiU2y3jEbQyEnmbbfagougaxGjv3ASxjj4D//BNZj8Kw9Hzp5NDqTstzzW6Tf+qZeHAIEgvSnE7vypr/nBgI343kTR5L/Hsy5YsFxCBSmmGSflEOISqyhHHbMWmn0EVu6lTuhIr5LjJrPOzxwC3IV42PYrYTTj5W/WwknHOR97THvzBRkSiBeGaZR63L+nLaIMdHmeo3fKv9y6OhDrfVzpmQqB2nGje5Th04zTrTA91D4zKr8odQXZGnSYpcX5Gsi81Mwq0R7hZi+MUCV1RzdaERbQuaE3EdjSdVe/tsIqNsNcKNBmtfyNHlg/uv2+18BVsR6Ue/qiw== cardno:16 059 950"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2DPFefvAKSAPuTGijgyx/ufOs7VWvNFZuEI4vouFB3boIxiRi7BSRo/rymWJyyXewzl7pJNwgSXaukVH8t3oOtk8Yy4ik9SsJCdnfZ4hXOhpct/Ps4Oj1EfZ3Axmr79mDrf/VirzZI5MfDjRPmwAXgburMFUaNg6DX/7BV1hs41Oee8f1QWM9C5Jfyqy+T88H8yMs5wipPkVqoJHfGGC1upPWi8h7YkTkatIOtuCKkzEL7513ISpLOurzBPoFOfyj+dviJ4i4WgjisG9EHUoyCFaz68IvIEiacpyg1N9Y1/81WonFeLMew795Y9VtSbna+u/VnVFRsFMcf+TkdfsZTzEq/45mUE+oIpq5V3RHCefbwVvDluYsJfsXVemD93lJUXudPaYM8IsWxZ71SKQiEVCUHggbiPssLNNQE3/spc2/is4mJWSE3TrA1Qx5z2zhAwYUugZ5ZX3op207ysFU4ZhLlvm8ew6saZOMJ7NlzJzrSo/FS6R4DxlEx7vReV0kMw81cwXmWVG73qhbfRiE9Nadui0BNbTIyRF60B5aZnO1EPEj22hU0hQzgXupFkEao8M8mMPOOC0lJV8POe9RK2xuFiXvFOr1YGlo94E2CNPLJHXHCZrc70zmpivAgEd96Iq4xYB1IWf1COwkhjSC+bz2nUDTdLiMVcZN3L8NVw== cardno:16 059 970"
      ];
    };
  };

  services.udisks2.enable = true;

  virtualisation.virtualbox.host.enable = true;
  #services.postgresql.enable = true;

  system.stateVersion = "18.03";
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # android_sdk.accept_license = true;
}
