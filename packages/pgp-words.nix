# Note to self: this isn't a function like in NixPkgs, because such
# functions *return* a derivation.  Here, we just want a derivation.
with (import <nixpkgs> {});
rustPlatform.buildRustPackage rec {
  pname = "pgp-words";
  version = "0.3.0.0";
  src = fetchFromGitHub {
    owner = "thblt";
    repo = "pgp-words.rs";
    rev = "4f20806663051ab96125d6d72115793c3d0cc441";
    # sha256 = lib.fakeHash; # To get the correct hash from the failed
    # build.
    sha256 = "sha256-LJOaZJqc/3I+J/pOSi0noX/5BHElukeWIxIkeyFiFSc=";
  };
  cargoHash = "sha256-GRp6krNSs/bWcnDUp+PHIFiTvXIKZsaYhMkhGkCHosA=";

  meta = with lib; {
    description = "Make hex sequences easier to communicate over the phone.";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/thblt/pgp-words.rs";
    maintainers = [];
  };
}
