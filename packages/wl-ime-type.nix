with (import <nixpkgs> {});
stdenv.mkDerivation {
  pname = "wl-ime-type";
  version = "0.0.0-85703f0e";
  src = fetchGit {
    url = "https://git.sr.ht/~emersion/wl-ime-type";
    rev = "85703f0e6cf844391b8ec87e635cf248a2e5a4dc";
    ref = "master";
  };
  nnnnoInstall = true;
  buildInputs =
    [ pkgconfig
      scdoc
      wayland
      wayland-scanner
    ];
  installPhase = "mkdir -p $out/bin
mkdir -p $out/share/man/man1
cp wl-ime-type $out/bin
cp wl-ime-type.1 $out/share/man/man1";
  description = "Type text via Wayland's input-method-unstable-v2 protocol.";
  license = "bsd2";
  hydraPlatforms = lib.platforms.none;
}
