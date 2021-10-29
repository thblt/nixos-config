with (import <nixpkgs> {});
let
  f = { mkDerivation, base, bytestring, containers, lib }:
    mkDerivation {
      pname = "aspell-merge3";
      version = "0.1.0.0";
      src = fetchGit {
        url = "https://github.com/thblt/aspell-merge3";
        rev = "623020281de8c6349230cdb4af6815260f776ed6";
      };
      isLibrary = false;
      isExecutable = true;
      executableHaskellDepends = with haskellPackages; [
        base
        bytestring
        containers
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
