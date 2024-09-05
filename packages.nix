{ config, lib, pkgs, ... }:
let
  emacsPrime = (pkgs.emacs.override {
    srcRepo = true;
    withGTK2 = false;
    withGTK3 = true; # GTK3 Emacs isn't wayland-native, it just adds the gtk bug https://emacshorrors.com/posts/psa-emacs-is-not-a-proper-gtk-application.html
    withPgtk = true;
    nativeComp = true;
  }).overrideAttrs ({version, ...}: {
    # name = "emacs-${version}-thblt";
    version = "29.0.50";
    src = builtins.fetchGit {
      url = "git://git.savannah.gnu.org/emacs.git";
      # ↓This is master.
      rev="f176a36f4629b56c9fd9e3fc15aebd04a168c4f5";
      # If rev is not in master, ref must be given.
      # ref="emacs-28";
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
    fzf

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
    usbutils
    wget
    whois
    zip unzip

    # ** Utilities

    (import ./packages/aspell-merge3.nix)
    (import ./packages/pgp-words.nix)
    bc
    gpp
    graphviz
    jq
    pandoc
    udiskie

    # ** Cryptography

    gnupg1compat
    gopass
    pinentry

    # ** Graphical utilities and appliations

    # *** Apps

    auto-multiple-choice
    chromium
    discord
    eduke32
    element-desktop
    evince
    (firefox.override { nativeMessagingHosts = [ passff-host ]; })
    gzdoom
    hugo
    krita
    imagemagick
    inkscape
    kicad
    libreoffice
    gnome3.eog
    gnome3.nautilus
    neofetch # I know.
    qmk
    qrencode
    scid-vs-pc
    signal-desktop
    spotify
    transmission-gtk
    vlc
    yt-dlp
    zotero

    # *** More apps

    zoom-us

    # *** Icon/cursor themes

    # gnome3.adwaita-icon-theme # For large mouse pointers

    # ** Emacs and friends

    ((emacsPackagesFor emacs29-pgtk).emacsWithPackages
      (epkgs: with epkgs; [ vterm notmuch treesit-grammars.with-all-grammars ] ))
    # Emacs overlay:
    # ((emacsPackagesFor emacsUnstablePgtk).emacsWithPackages
    #   (epkgs: [ epkgs.vterm epkgs.notmuch ]))

    # (pkgs.writeScriptBin "emacs-treesit" "${pkgs.emacsGitTreeSitter}/bin/emacs \"$@\"")
    isync
    aspell
    aspellDicts.fr
    aspellDicts.en
    hunspell
    hunspellDicts.fr-any
    mu
    notmuch
    afew

    # enemies
    helix
    neovim
    neovim-qt
    vscodium

    # ** Programming tools

    # *** Language-independent

    cloc
    ctags
    gitFull
    gnumake
    meld
    nix-prefetch-scripts
    ripgrep
    llvmPackages.bintools  # This is generally useful.

    # *** The C family

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

    (latest.rustChannels.stable.rust.override {
      extensions = [ "rust-src" #"rust-analysis"
                   ];})
    # rustup
    #latest.rustChannels.stable.rust-src
    #latest.rustChannels.stable.rustc
    cargo-web
    diesel-cli
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
    #texlive.combined.scheme-full
    (texlive.combine {
      inherit (pkgs.texlive) scheme-full;
      extra =
        {
          pkgs = [ auto-multiple-choice ];
        };
    })
  ];
}
