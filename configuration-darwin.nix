{ config, pkgs, inputs, ... }: {
  nix.enable = false;

  imports = [ ./packages.nix ];
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [ pkgs.iosevka pkgs.fira-code ];

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  environment.variables = {
    SSH_AUTH_SOCK="/Users/thblt/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";

  };

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
