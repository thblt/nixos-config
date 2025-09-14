{
  description = "A flake for my computers";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix/25.07";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    pgp-words.url = "github:thblt/pgp-words.rs/main";
    pgp-words.inputs.nixpkgs.follows = "nixpkgs";
    aspell-merge3.url = "github:thblt/aspell-merge3/main";
    aspell-merge3.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixos, home-manager, nixos-wsl, nix-darwin, ... }: {

    # DRU (Thinkpad X270)
    nixosConfigurations.dru = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration-dru.nix ];
    };

    # MARGOLOTTA
    nixosConfigurations.margolotta = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration-margolotta.nix
        home-manager.nixosModules.home-manager
      ];
    };

    # WSL
    nixosConfigurations.nixos = nixos.lib.nixosSystem {
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
      system.configurationRevision = self.rev or self.dirtyRev or null;
      modules =
        [ home-manager.darwinModules.home-manager ./configuration-darwin.nix ];
    };
  };
}
