{ config, pkgs, inputs, ... }: {
  # Base system programs
  environment.systemPackages = with pkgs;
    [

      # ** Shell

      tmux
      fzf
      grc

      fishPlugins.autopair
      fishPlugins.done
      fishPlugins.fzf-fish
      fish-lsp

      # ** Common system utilities
      acpi
      lm_sensors
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
      zip
      unzip

      # ** Utilities

      # (import ./packages/aspell-merge3.nix)
      inputs.pgp-words.outputs.defaultPackage."${pkgs.system}"
      inputs.helix.packages."${pkgs.system}".helix

      bc
      eza
      gpp
      graphviz
      jless
      jq
      pandoc
      tre-command
      udiskie

      # ** Cryptography

      gnupg1compat
      gopass
      pinentry

      # ** Graphical utilities and appliations

      # *** Apps

      auto-multiple-choice
      hugo
      imagemagick
      neofetch # I know.
      nextcloud-client
      obsidian
      qmk
      qrencode
      yt-dlp
      zettlr
      zotero

      # *** More apps

      # ** Emacs and friends
      ((emacsPackagesFor emacs30-gtk3).emacsWithPackages (epkgs:
        with epkgs; [
          auctex
          auto-compile
          backline
          beginend
          bicycle
          consult
          corfu
          diminish
          dirvish
          doom-themes
          editorconfig
          eldoc-box
          embark
          embark-consult
          emmet-mode
          erc-hl-nicks
          evil-nerd-commenter
          f
          flyspell-correct
          forge
          free-keys
          haskell-mode
          hydra
          loccur
          magit
          marginalia
          markdown-mode
          mwim
          nix-mode
          no-littering
          notmuch
          orderless
          outline-minor-faces
          pdf-tools
          rainbow-mode
          rg
          s
          scpaste
          shackle
          smartparens
          super-save
          sway
          tablist
          treepy
          treesit-grammars.with-all-grammars
          unfill
          unkillable-scratch
          vertico
          visual-fill-column
          visual-regexp
          vterm
          vundo
          wgrep
          with-editor
          yaml
          yasnippet
          aggressive-indent
        ]))
      isync
      (aspellWithDicts (dicts: with dicts; [ aspellDicts.fr aspellDicts.en ]))
      mu
      notmuch
      afew

      # enemies
      helix
      neovim
      neovim-qt

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
      racket
      chez
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
    ] ++ lib.optionals (!config.wsl.enable) [
      # Large graphical programs we don't need/want in WSL
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
