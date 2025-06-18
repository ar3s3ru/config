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
    ../modules/nix-unstable.nix
    ../modules/nixpkgs.nix
    ../modules/fish.nix
    ../modules/aerospace.nix
    ./configuration.nix
    ./homebrew.nix
    ./docker.nix
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ar3s3ru = import ./user-ar3s3ru.nix;

      home-manager.extraSpecialArgs.inputs = inputs;
      home-manager.extraSpecialArgs.colorscheme = nix-colors.colorSchemes.monokai;
      home-manager.extraSpecialArgs.ssh.private-key = ./secrets/id_ed25519;
      home-manager.extraSpecialArgs.ssh.public-key = ./id_ed25519.pub;
    }
  ];
}
