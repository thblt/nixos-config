{ pkgs, lib, inputs, stdenv, ... }:
# Ascii art font is Pagga
let
  is-darwin = (pkgs.system == "aarch64-darwin");

  flake-root = if is-darwin then "/etc/nix-darwin/" else "/etc/nixos/";
  my-pinentry = if is-darwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3;

  my-public-ssh-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0KP6qcGX9MKolHQd+43v+HyQijegFMoQg+AxDii2vq";

in {
  home-manager.users.thblt = { config, ... }: {

    # ░█▀▄░▀█▀░▀█▀░█░█░█▀█░█▀▄░█▀▄░█▀▀░█▀█
    # ░█▀▄░░█░░░█░░█▄█░█▀█░█▀▄░█░█░█▀▀░█░█
    # ░▀▀░░▀▀▀░░▀░░▀░▀░▀░▀░▀░▀░▀▀░░▀▀▀░▀░▀

    # From the doc: you need to `rbw register` before you `rbw login`
    programs.rbw = {
      enable = true;
      settings = {
        email = "thibault@thb.lt";
        base_url = "https://api.bitwarden.eu/";
        pinentry = my-pinentry;
      };
    };

    home.sessionVariables."SSH_AUTH_SOCK" = if is-darwin then
      "$(getconf DARWIN_USER_TEMP_DIR)rbw-$(id -u)/ssh-agent-socket"
    else
    # ~ doesn't seem to work here.
      "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";

    # ░█▀▀░█░█░█▀▀░█░░░█░░
    # ░▀▀█░█▀█░█▀▀░█░░░█░░
    # ░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
        {
          name = "fish-done";
          src = pkgs.fishPlugins.done.src;
        }
      ];
    };

    programs.eza.enable = true;
    home.shell.enableFishIntegration = true;

    # zsh MUST be enabled, so values in home.sessionVariables are
    # correctly set in it, and in turn correctly found by
    # exec-path-from-shell in Emacs.
    programs.zsh.enable = true;

    # ░█▀▀░█▄█░█▀█░▀█▀░█░░
    # ░█▀▀░█░█░█▀█░░█░░█░░
    # ░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀

    accounts.email = {
      maildirBasePath = ".mail";

      accounts.personal = {
        primary = true;
        address = "thibault@thb.lt";
        userName = "thibault@thb.lt";
        realName = "Thibault Polge";
        imap.host = "ssl0.ovh.net";
        imap.tls.enable = true;
        smtp.host = "ssl0.ovh.net";
        smtp.tls.enable = true;
        passwordCommand = "rbw get ssl0.ovh.net";
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        notmuch.enable = true;
      };

      accounts.work = {
        address = "thibault.polge@ac-amiens.fr";
        userName = "tpolge";
        realName = "Thibault Polge";
        imap.host = "imap.ac-amiens.fr";
        imap.tls.enable = true;
        smtp.host = "smtp.ac-amiens.fr";
        smtp.tls.enable = true;
        passwordCommand = "rbw get ac-amiens.fr";
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        notmuch.enable = true;
      };

    };

    programs.notmuch = {
      enable = true;
      new.tags = [ "new" ];
    };
    programs.mbsync = { enable = true; };

    # ░█▀▀░▀█▀░▀█▀
    # ░█░█░░█░░░█░
    # ░▀▀▀░▀▀▀░░▀░

    programs.git = {
      enable = true;
      userName = "Thibault Polge";
      userEmail = "thibault@thb.lt";
      signing = {
        signByDefault = true;
        format = "ssh";
        key = my-public-ssh-key;
      };
      extraConfig = {
        init.defaultBranch = "main";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        url."ssh://git@github.com/".pushInsteadOf = "https://github.com/";
        url."ssh://git@gitlab.com/".pushInsteadOf = "https://gitlab.com/";
        url."ssh://git@git.sr.ht/".pushInsteadOf = "https://git.sr.ht/";

        merge."aspell-merge3" = {
          name = "A merge driver for aspell custom dictionaries.";
          driver = "${
              inputs.aspell-merge3.outputs.packages.${pkgs.system}.default
            }/bin/aspell-merge3 %O %A %B --output %A";
        };
      };

      ignores = [
        "#*#"
        "*-autoloads.el"
        "*.elc"
        "*.info"
        "*.swp"
        "*.synctex.gz"
        "*.un~"
        "*~"
        ".*.~undo-tree~"
        ".DS_Store"
        ".stack-work"
        ".~lock*"
        "TAGS"
        "_region_.tex"
        "a.out"
        "dir"
        "dist-newstyle"
        "ltximg"
        "ltxpng"
        "missfont.log"
        "tags"
      ];
    };

    home.file.".ssh/allowed_signers".text =
      "thibault@thb.lt ${my-public-ssh-key}";

    # ░█░█░█▀▀░█░░░▀█▀░█░█
    # ░█▀█░█▀▀░█░░░░█░░▄▀▄
    # ░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀

    programs.helix = { enable = true; };

    # ░█▀▀░█▄█░█▀█░█▀▀░█▀▀
    # ░█▀▀░█░█░█▀█░█░░░▀▀█
    # ░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀

    programs.emacs = {
      enable = true;
      package = ((pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs:
        with epkgs;
        [
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
        ] ++ lib.optionals is-darwin [ epkgs.exec-path-from-shell ]));
    };

    services.emacs = { enable = true; };

    # ░█░█░█▀▀░▀▀█░▀█▀░█▀▀░█▀▄░█▄█
    # ░█▄█░█▀▀░▄▀░░░█░░█▀▀░█▀▄░█░█
    # ░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀░▀

    programs.wezterm = { enable = true; };

    xdg.configFile."wezterm/wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${flake-root}/dotfiles/wezterm.lua";
  };
}
