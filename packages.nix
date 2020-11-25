{ config, lib, pkgs, ... }:
let
  emacsPrime = (pkgs.emacs.override {
    srcRepo = true;
    withGTK2 = false;
    withGTK3 = false; # GTK3 Emacs isn't wayland-native, it just adds the gtk bug https://emacshorrors.com/posts/psa-emacs-is-not-a-proper-gtk-application.html
    nativeComp = true;
  }).overrideAttrs ({version, ...}: {
        # name = "emacs-${version}-thblt";
    version = "28.1";
    src = builtins.fetchGit {
      url = "git://git.savannah.gnu.org/emacs.git";
      rev = "c390141d39790bda2ac836a6ae03d5f02c58cdd4";
      #ref = "emacs-27.1";
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
    unrar
    wget
    whois
    zip unzip

    # ** Utilities

    bc
    graphviz
    pandoc
    udiskie

    # ** Crypto

    gnupg1compat
    gopass
    pinentry

    # ** X11 and X utilities

    # *** Apps

    chromium
    evince
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    krita
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

    (emacs.override { withGTK3 = false; nativeComp = false; })
    # emacsPrime
    isync
    aspell
    aspellDicts.fr
    aspellDicts.en
    hunspell
    hunspellDicts.fr-any
    notmuch

    # ** Programming tools

    # *** Language-independent

    cloc
    gitFull
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

    python3

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
