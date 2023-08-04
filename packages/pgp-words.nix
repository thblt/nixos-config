# Note to self: this isn't a function like in NixPkgs, because such
# functions *return* a derivation.  Here, we just want a derivation.
with (import <nixpkgs> {});
rustPlatform.buildRustPackage rec {
  pname = "pgp-words";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "thblt";
    repo = "pgp-words.rs";
    rev = "47b0d8b7b1f46860e47cc0f4b74a2affc8a26fe7";
    # sha256 = lib.fakeHash; # To get the correct hash from the failed
    # build.
    sha256 = "sha256-JgSkiDCd3GJ+VYH3u/PY7bNSDsYgKebztS6cjdkrUfg=";
  };
  cargoHash = "sha256-PmgkgNcWy66kA3I73ZIMG5LgGmTV9a3gta6YQw7VbYg=";

  meta = with lib; {
    description = "Turn hex strings into simple words for easy verification.";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/thblt/pgp-words.rs";
    maintainers = [ nixpkgs.maintainers.thblt ];
  };
}
