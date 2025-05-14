{ darwin, home-manager, nix-colors, ... }@inputs:
let
  nixpkgs = import inputs.nixpkgs {
    config.allowUnfree = true;
    config.allowUnsupportedSystem = true;
    config.allowBroken = true;
  };
in
darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  inputs = { inherit darwin nixpkgs; };
  modules = [
    home-manager.darwinModules.home-manager
    nix-colors.homeManagerModule
    (import ../../modules/all/home-manager.nix inputs)
    ../../modules/all/nix-unstable.nix
    ../../modules/all/nixpkgs.nix
    ../../modules/all/fish.nix
    ../../modules/darwin/aerospace.nix
    ./configuration.nix
    ./homebrew.nix
    ./java.nix
    ./users/ar3s3ru
  ];
}
