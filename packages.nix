{ config, lib, pkgs, ... }:
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  emacsPrime = (pkgs.emacs.override {
        srcRepo = true;
        withGTK2 = false;
        withGTK3 = false;
      }).overrideAttrs ({name, version, versionModifier, ...}: {
        name = "emacs-${version}${versionModifier}";
        version = "HEAD";
        versionModifier = "";
        src = builtins.fetchGit {
          url = "https://git.savannah.gnu.org/git/emacs.git";
          rev = "7b0216fbc0a1051e6f3bee5bf6c2435b2b3a1ddf";
        };
        # configureFlags = configureFlags ++ ["--with-imagemagick"];
        # buildInputs = buildInputs ++ [ pkgs.imagemagick ];
        autoconf = true;
        automake = true;
        texinfo = true;
        patches = [];
      });
in
{
  #chromium.enablePepperFlash = true;
  #oraclejdk.accept_license = true;

  # Base system programs
  environment.systemPackages = with pkgs; [
    (all-hies.selection { selector = p: { inherit (p) ghc865 ghc882; }; })
    acpi
    cachix
    file
    pciutils
    powertop
    psmisc

    # ** Shell

    tmux

    # ** Common system utilities

    acpi lm_sensors
    bind
    htop
    p7zip
    tree
    unrar
    wget
    whois
    zip unzip

    # ** Less common utilities

    bc
    graphviz
    udiskie

    # ** Crypto

    gnupg1compat
    pass
    pinentry

    # ** X11 and X utilities

    # *** Apps

    chromium
    evince
    firefox-bin
    gimp
    hugo
    jabref
    imagemagick
    inkscape
    libreoffice
    gnome3.nautilus
    qrencode
    scantailor-advanced
    scribus
    transmission-gtk
    vlc
    youtube-dl
    zotero

    # *** Icon/cursor themes

    gnome3.adwaita-icon-theme # For large mouse pointers

    # ** Emacs and friends

    emacsPrime
    isync
    aspell
    aspellDicts.fr
    aspellDicts.en

    hunspell
    hunspellDicts.fr-any

    # ** Programming tools

    # *** Language-independent

    gitFull
    gitAndTools.git-hub
    meld
    nix-prefetch-scripts
    ripgrep

    # ***  The C family
    clang

    # *** Go

    go

    # *** Haskell

    haskellPackages.apply-refact
    hlint
    haskellPackages.hoogle
    stack

    # *** Python

    python36

    # *** Lisps

    racket
    chez

    # *** Rust

    cargo
    rustc
    rustfmt
    rust-analyzer

    # ** *TeX

    asymptote
    lyx
    #texlive.biber
    texlive.combined.scheme-full
  ];
}
