{pkgs, config, ...}: {

  imports = [ "/etc/nixos/roles/interactive.nix" ];

  system.stateVersion = "17.09";

  services.pcscd.enable = true;

  environment.systemPackages = [ pkgs.fwupd pkgs.glib_networking ];
  systemd.packages = [ pkgs.fwupd ];

  environment.variables =
	{ GIO_EXTRA_MODULES = "${pkgs.glib_networking.out}/lib/gio/modules:${pkgs.gnome3.dconf}/lib/gio/modules";
          GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings_desktop_schemas}/share/gsettings-schemas/gsettings-desktop-schemas-3.22.0/glib-2.0/schemas";
        };

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

  services.xserver.displayManager.lightdm.autoLogin = {
    enable = true;
    user = "thblt";
  };

  time.timeZone = "Europe/Paris";
}
