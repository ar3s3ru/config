inputs@{ nix-colors, nixpkgs, sops-nix, ... }:
let
  lib = nixpkgs.lib;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs.inputs = inputs;
  home-manager.extraSpecialArgs.colorscheme = lib.mkDefault nix-colors.colorSchemes.monokai;
  home-manager.sharedModules = [
    sops-nix.homeManagerModules.sops
    nix-colors.homeManagerModule
  ];
}
