{pkgs, lib, ...}: {
  i18n = {
    consoleFont = pkgs.lib.mkForce "${pkgs.terminus_font}/share/consolefonts/ter-i32n.psf.gz";
  };
  services.xserver.dpi = 289;
  fonts.fontconfig.dpi = 289;
}
