{ config, pkgs, ... }: {
  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = config.nix.enable;
      options = "--delete-older-than 8d";
    };
  };

  imports = [ ./packages.nix ./home.nix ];

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [ pkgs.iosevka pkgs.fira-code ];

  # Fish must be enabled from nix-darwin, and not just home-manager,
  # to correctly set nix paths in interactive use.
  programs.fish.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.thblt = { home = "/Users/thblt"; };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  home-manager.users.thblt.home.stateVersion = "25.11";
}
