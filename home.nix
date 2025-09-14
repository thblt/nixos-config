{ pkgs, lib, inputs, stdenv, ... }:
let
  is-darwin = (pkgs.system == "aarch64-darwin");

  my-root = if is-darwin then "/etc/nix-darwin/" else "/etc/nixos/";

  my-public-ssh-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0KP6qcGX9MKolHQd+43v+HyQijegFMoQg+AxDii2vq";

in {
  home-manager.users.thblt = { config, ... }: {

    home.sessionVariables."SSH_AUTH_SOCK" = if is-darwin then
      "~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    else
    # ~ doesn't seem to work here.
      "$HOME/.bitwarden-ssh-agent.sock";

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
    home.shell.enableFishIntegration = true;

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
        ] ++ lib.optionals (pkgs.system == "aarch64-darwin")
        [ epkgs.exec-path-from-shell ]));
    };

    services.emacs = { enable = true; };

    # ░█░█░█▀▀░▀▀█░▀█▀░█▀▀░█▀▄░█▄█
    # ░█▄█░█▀▀░▄▀░░░█░░█▀▀░█▀▄░█░█
    # ░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀░▀

    programs.wezterm = { enable = true; };

    xdg.configFile."wezterm/wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "/etc/nix-darwin/dotfiles/wezterm.lua";
  };
}
