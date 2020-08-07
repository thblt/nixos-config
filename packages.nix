{ config, lib, pkgs, ... }:
let
  emacsPrime = (pkgs.emacs.override {
    srcRepo = true;
    withGTK2 = false;
    withGTK3 = false; # GTK3 Emacs isn't wayland-native, it just adds the gtk bug https://emacshorrors.com/posts/psa-emacs-is-not-a-proper-gtk-application.html
      }).overrideAttrs ({name, version, ...}: {
        name = "emacs-${version}-thblt";
        version = "27.1";
        src = builtins.fetchGit {
          url = "git://git.savannah.gnu.org/emacs.git";
          #rev = "86d8d76aa36037184db0b2897c434cdaab1a9ae8";
          ref = "emacs-27.1-rc2";
        };
        autoconf = true;
        automake = true;
        texinfo = true;
        patches = [];
      });
in
{
  #chromium.enablePepperFlash = true;
  # oraclejdk.accept_license = true;

  # Base system programs
  environment.systemPackages = with pkgs; [

    # ** Shell

    tmux

    # ** Common system utilities

    acpi lm_sensors
    bind
    file
    htop
    p7zip
    pciutils
    powertop
    psmisc
    tldr
    tree
    udiskie
    unrar
    wget
    whois
    zip unzip

    # ** Utilities

    bc
    graphviz

    # ** Crypto

    gnupg1compat
    gopass
    pinentry

    # ** X11 and X utilities

    # *** Apps

    chromium
    evince
    firefox-bin
    gimp
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
    llvmPackages.bintools  # This is generally useful.

    # ***  The C family
    clang

    # *** Go

    go

    # *** Haskell

    cabal-install
    ghc
    haskellPackages.apply-refact
    haskellPackages.haskell-language-server
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
    cargo-edit
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
