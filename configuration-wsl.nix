{ config, lib, pkgs, ... }:

{
  imports = [ ./common.nix ./packages.nix ./home.nix ];

  wsl.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  programs.sway.enable = lib.mkForce false;
  users.extraUsers.thblt.password = "";
  users.extraUsers.thblt.shell = pkgs.fish;

  wsl.defaultUser = "thblt";

  environment.variables = {
    # Allows OpenSSH to use a FIDO2 ssh key from the Windows host.
    SSH_SK_HELPER = "/mnt/c/Windows/System32/OpenSSH/ssh-sk-helper.exe";
  };

  home-manager.users.thblt.home.stateVersion = "25.11";
  system.stateVersion = "24.05";

}
