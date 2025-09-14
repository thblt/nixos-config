{ config, pkgs, inputs, ... }: {
  # Base system programs
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  environment.systemPackages = with pkgs;

  # Linux hardware support (Linux all the way down)
    lib.optionals (stdenv.isLinux && !config ? wsl.enable) [
      acpi
      bind
      lm_sensors
      pciutils
      powertop
      usbutils
    ] ++

    # Base system (Linux only, not on Darwin)
    lib.optionals (stdenv.isLinux) [

      acpi
      file
      htop
      p7zip
      psmisc
      tldr
      tree
      unrar
      wget
      whois
      zip
      unzip
      udiskie

      # ** Cryptography

      gnupg1compat
      gopass
    ] ++

    # Common packages
    [
      # ** Shell
      tmux
      fzf
      grc
      zellij

      # fishPlugins.fzf-fish
      fish-lsp

      # ** Utilities

      #inputs.pgp-words.outputs.defaultPackage."${pkgs.system}"
      #inputs.helix.packages."${pkgs.system}".helix

      bc
      eza
      gpp
      graphviz
      jless
      jq
      pandoc
      tre-command

      # ** Graphical utilities and appliations

      # *** Apps

      hugo
      imagemagick
      neofetch # I know.
      qmk
      qrencode
      yt-dlp

      # *** More apps

      # ** Emacs and friends
      mu
      notmuch
      afew

      # enemies
      helix

      # ** Programming tools

      # *** Language-independent
      cloc
      ctags
      gitFull
      gnumake
      nix-prefetch-scripts
      ripgrep
      llvmPackages.bintools # This is generally useful.
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
      nixfmt-classic
      # *** Lisps
      chez
      # racket # Fails on Darwin
      # *** Python
      python3
      pylint
      ruff # LSP
      # *** Rust
      pkgs.rust-bin.stable.latest.default
      diesel-cli
      rustfmt
      rust-analyzer
      # ** Shell
      bash-language-server
      # ** Text
      marksman # LSP for Markdown
      # ** *TeX
      asymptote
      (texlive.combine {
        inherit (texlive) scheme-full;
        extra = { pkgs = [ auto-multiple-choice ]; };
      })
      # *** Web
      nodePackages.prettier
      nodejs
      sass
      yarn

    ] ++

    # Large graphical programs that should only be installed in real Linux
    lib.optionals (stdenv.isLinux && !config ? wsl.enable) [
      # Large graphical programs we don't need/want in WSL
      auto-multiple-choice
      bitwarden
      chromium
      discord
      eduke32
      element-desktop
      evince
      (firefox.override { nativeMessagingHosts = [ passff-host ]; })
      gzdoom
      krita
      inkscape
      insomnia # Rest client
      kicad
      libreoffice
      eog
      nautilus
      scid-vs-pc
      signal-desktop
      spotify
      transmission_4-gtk
      vlc
      zotero
      zoom-us
      vscodium
      meld
      lyx
    ];
}
