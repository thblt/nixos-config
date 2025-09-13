{ pkgs, ... }: {
  nix.enable = false;

  imports = [ ./packages.nix ./home.nix ];

  nix.settings.experimental-features = "nix-command flakes";

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [ pkgs.iosevka pkgs.fira-code ];

  environment.variables = {
    SSH_AUTH_SOCK =
      "/Users/thblt/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
  };

  # Fish must be enabled from nix-darwin, and not just home-manager,
  # to correctly set nix paths in interactive use.
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  home-manager.users.thblt.home.stateVersion = "25.11";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.thblt = { home = "/Users/thblt"; };
}
