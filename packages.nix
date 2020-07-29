{ config, lib, pkgs, ... }:
let
  emacsPrime = (pkgs.emacs.override {
    srcRepo = true;
    withGTK2 = false;
    withGTK3 = false; # GTK3 Emacs isn't wayland-native, it just adds the gtk bug https://emacshorrors.com/posts/psa-emacs-is-not-a-proper-gtk-application.html
      }).overrideAttrs ({name, version, versionModifier, ...}: {
        name = "emacs-${version}${versionModifier}";
        version = "HEAD";
        versionModifier = "";
        src = builtins.fetchGit {
          url = "https://git.savannah.gnu.org/git/emacs.git";
          rev = "609cbd63c31a21ca521507695abeda1203134c99";
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
