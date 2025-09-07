{
  description = "A flake for my computers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pgp-words = {
      url = "github:thblt/pgp-words.rs/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/25.07";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, nixos-wsl, nix-darwin, rust-overlay, ... }: {
      # DRU (Thinkpad X270)
      nixosConfigurations.dru = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./configuration-dru.nix nixos-wsl.nixosModules.default ];
      };

      # MARGOLOTTA
      nixosConfigurations.margolotta = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [ ./configuration-margolotta.nix nixos-wsl.nixosModules.default ];
      };

      # WSL
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-wsl.nixosModules.default
          {
            # Set this here, so multiple WSL hosts in the future can
            # have different stateVersion with the same config module.
            system.stateVersion = "24.05";
            wsl.enable = true;
          }
          ./configuration-wsl.nix
        ];
      };

      # Darwin
      darwinConfigurations."MBA-Thibault" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./configuration-darwin.nix ];
      };
    };
}
