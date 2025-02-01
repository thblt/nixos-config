{ pkgs, ... }:
{
  # Base system programs
  environment.systemPackages = with pkgs; [

    # ** Shell

    tmux
    fzf
    grc

    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    # fishPlugins.hydro
    fishPlugins.grc
    fishPlugins.tide
    fish-lsp

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

    # (import ./packages/aspell-merge3.nix)
    # (import ./packages/pgp-words.nix)
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
    #kicad
    libreoffice
    eog
    nautilus
    neofetch # I know.
    nextcloud-client
    qmk
    qrencode
    scid-vs-pc
    signal-desktop
    spotify
    transmission_4-gtk
    vlc
    yt-dlp
    zotero

    # *** More apps

    zoom-us

    # ** Emacs and friends
    ((emacsPackagesFor emacs30-gtk3).emacsWithPackages
      (epkgs: with epkgs; [ auctex forge magit pdf-tools vterm notmuch treesit-grammars.with-all-grammars ] ))
    isync
    (aspellWithDicts
      (dicts: with dicts; [ aspellDicts.fr
                            aspellDicts.en ]))
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
    # *** The C family
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
    # *** Nix
    nixd
    # *** Lisps
    racket
    chez
    # *** Python
    python3
    pylint
    ruff # LSP
    # *** Rust
    pkgs.rust-bin.stable.latest.default
    cargo-web
    diesel-cli
    rustfmt
    rust-analyzer
    # ** Text
    marksman # LSP for Markdown
    # ** *TeX
    asymptote
    lyx
    (texlive.combine {
      inherit (texlive) scheme-full;
      extra =
        {
          pkgs = [ auto-multiple-choice ];
        };
    })
    # *** Web
    nodePackages.prettier
    nodejs
    sass
    yarn
    insomnia # Rest client
  ];
  }
