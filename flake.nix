{
  description = "Dani's NixOS system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    nix-colors.url = "github:misterio77/nix-colors";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, nix-colors, darwin, nur, disko, nixos-apple-silicon, ... }@inputs:
    let
      stateVersion = "23.05";

      homeManagerConfig = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };

      extraSpecialArgs = {
        # NOTE: this is to pass nix-colors to the other modules.
        inherit inputs;

        # Color scheme to be used for all applications.
        colorscheme = nix-colors.colorSchemes.atelier-dune;
      };
    in
    {
      nixosConfigurations = {
        momonoke = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/momonoke/configuration.nix
            ./derivations/overlay.nix
            disko.nixosModules.disko
            nixos-hardware.nixosModules.lenovo-thinkpad-x270
            home-manager.nixosModules.home-manager
            (homeManagerConfig // {
              home-manager.users.ar3s3ru = import ./home/ar3s3ru/momonoke.nix;
              home-manager.extraSpecialArgs = (extraSpecialArgs // {
                wallpaper = ./wallpapers/majelletta.jpg;

                # SSH configuration for user.
                ssh = {
                  private-key = ./machines/momonoke/secrets/id_ed25519;
                  public-key = ./machines/momonoke/id_ed25519.pub;
                };
              });
            })
          ];
        };
        dejima = import ./machines/dejima inputs;
      };

      darwinConfigurations = {
        teriyaki = import ./machines/teriyaki inputs;
      };
    };
}
