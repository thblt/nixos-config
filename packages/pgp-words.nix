# Note to self: this isn't a function like in NixPkgs, because such
# functions *return* a derivation.  Here, we just want a derivation.
with (import <nixpkgs> {});
rustPlatform.buildRustPackage rec {
  pname = "pgp-words";
  version = "0.1.0.0";
  src = fetchFromGitHub {
    owner = "thblt";
    repo = "pgp-words.rs";
    rev = "a99a345f6d984b4f65b08593ff8e0dcc45143f85";
    # sha256 = lib.fakeHash; # To get the correct hash from the failed
    # build.
    sha256 = "sha256-coopE2BlA9GM/JxSAK+N/g2CIf2iwQ0GHaueEgJLsyA=";
  };
  cargoHash = "sha256-+b8ubVfybGA4NAu39GmYGwDAUnabbBN1VcKgv84xbzk=";

  meta = with lib; {
    description = "Make hex sequences easier to communicate over the phone.";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/thblt/pgp-words.rs";
    maintainers = [];
  };
}
