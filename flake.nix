{
  description = "A flake for my computers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pgp-words.url = "github:thblt/pgp-words.rs/main";
    helix.url = "github:helix-editor/helix/25.01";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, ... }: {
    # DRU (Thinkpad X270)
    nixosConfigurations.dru = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration-dru.nix
        { nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ]; }
      ];
    };

    # MARGOLOTTA
    nixosConfigurations.margolotta = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration-margolotta.nix
        { nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ]; }
      ];
    };

    # WSL
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nixos-wsl.nixosModules.default
        {
          system.stateVersion = "24.05";
          wsl.enable = true;
        }
        { nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ]; }
        ./configuration-wsl.nix
      ];
    };
  };
}
