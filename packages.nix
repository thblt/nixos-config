{ config, lib, pkgs, ... }:
let
  emacsPrime = (pkgs.emacs.override {
    srcRepo = true;
    withGTK2 = false;
    withGTK3 = false; # GTK3 Emacs isn't wayland-native, it just adds the gtk bug https://emacshorrors.com/posts/psa-emacs-is-not-a-proper-gtk-application.html
    nativeComp = true;
  }).overrideAttrs ({version, ...}: {
    # name = "emacs-${version}-thblt";
    version = "28.0.50";
    src = builtins.fetchGit {
      url = "git://git.savannah.gnu.org/emacs.git";
      rev="0377737c9b3c72dd45f32ec0ffa6c4fa9cb0203d";
      #ref = "emacs-27.2";
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
    scid-vs-pc
    scribusUnstable
    transmission-gtk
    vlc
    youtube-dl
    zotero

    # *** Icon/cursor themes

    gnome3.adwaita-icon-theme # For large mouse pointers

    # ** Emacs and friends

    #(emacs.override { withGTK3 = false; nativeComp = false; })
    emacsPrime
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
    ctags
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
    stylish-haskell
    stack

    # *** Python

    python3

    # *** Lisps

    racket
    chez

    # *** Rust

    cargo
    cargo-edit
    cargo-web
    diesel-cli
    rustc
    rustfmt
    rust-analyzer

    # *** Web

    nodePackages.prettier
    nodejs
    sass
    yarn
    insomnia # Rest client

    # ** *TeX

    asymptote
    lyx
    #texlive.biber
    texlive.combined.scheme-full
  ];
}
