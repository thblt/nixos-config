with (import <nixpkgs> {});
let
  f = { mkDerivation, base, bytestring, containers, lib }:
    mkDerivation {
      pname = "aspell-merge3";
      version = "0.2.0.0";
      src = fetchFromGitHub {
        owner = "thblt";
        repo = "aspell-merge3";
        rev = "86541fbc80f3717ca185747808b1a09ac1cf1885";
        sha256 = "sha256-iJOOTdtlMIIpcVHKFYUYsAp0XtGNcGMVffdi/Tcj7nU=";
      };
      isLibrary = false;
      isExecutable = true;
      executableHaskellDepends = with haskellPackages; [
        base
        bytestring
        containers_0_6_7
        optparse-applicative ];
      description = "Automatic three-way merge for aspell personal dictionaries";
      license = "unknown";
      hydraPlatforms = lib.platforms.none;
      };

      haskellPackages = pkgs.haskellPackages;
      variant = pkgs.lib.id;

      drv = variant (haskellPackages.callPackage f {});
in

if pkgs.lib.inNixShell then drv.env else drv
