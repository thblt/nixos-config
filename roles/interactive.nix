# This role is for machines with interactive users, either local or over SSH.

{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
                                           file
                                           pciutils
                                           psmisc

                                           vim
                                           emacs
                                           ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

}
