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
  };

  outputs = inputs@{ self, nixpkgs,... }: {
    # DRU (Thinkpad X270)
    nixosConfigurations.dru = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration-dru.nix
        {nixpkgs.overlays = [
           inputs.rust-overlay.overlays.default
         ];}

      ];
    };
    # MARGOLOTTA
    nixosConfigurations.margolotta = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration-margolotta.nix
        {nixpkgs.overlays = [
           inputs.rust-overlay.overlays.default
         ];}
      ];
    };
  };
}
