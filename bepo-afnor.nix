{ config, lib, pkgs, ... }: {
  nixpkgs.config = {
    packageOverrides = super: rec {

      xorg = super.xorg // rec {
        xkeyboardconfig_thblt = super.xorg.xkeyboardconfig.overrideAttrs
          (old: { patches = [ ./bepo-afnor.patch ]; });

        xorgserver = super.xorg.xorgserver.overrideAttrs (old: {
          configureFlags = old.configureFlags ++ [
            "--with-xkb-bin-directory=${xkbcomp}/bin"
            "--with-xkb-path=${xkeyboardconfig_thblt}/share/X11/xkb"
          ];
        });

        setxkbmap = super.xorg.setxkbmap.overrideAttrs (old: {
          postInstall = ''
            mkdir -p $out/share
            ln -sfn ${xkeyboardconfig_thblt}/etc/X11 $out/share/X11
          '';
        });

        xkbcomp = super.xorg.xkbcomp.overrideAttrs (old: {
          configureFlags =
            "--with-xkb-config-root=${xkeyboardconfig_thblt}/share/X11/xkb";
        });

      };

      xkbvalidate = super.xkbvalidate.override {
        libxkbcommon = super.libxkbcommon.override {
          xkeyboard_config = xorg.xkeyboardconfig_thblt;
        };
      };
    };
  };
}
