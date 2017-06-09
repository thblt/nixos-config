{pkgs, config, ...}: {

  imports = [ "/etc/nixos/roles/interactive.nix" ];

  system.stateVersion = "17.03";
  nixpkgs.config.allowUnfree = true;

  services.pcscd.enable = true;

# Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    libinput = {
      enable = true;
      disableWhileTyping = true;
    };
    displayManager.lightdm = {
      enable = true;
    };
  };

  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    extraUsers.thblt = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      uid = 1000;
    };
  };
}
