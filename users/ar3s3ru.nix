{ lib, pkgs, inputs, ... }:

{
  home.username = "ar3s3ru";
  home.stateVersion = lib.mkDefault "22.05";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.allowBroken = true;

  # FIXME: fish-completions is pulling in Python 2.7 but it breaks the build.
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.7"
  ];

  imports = [
    inputs.nix-colors.homeManagerModule
    ../modules/home/nvim
    ../modules/home/alacritty.nix
    ../modules/home/direnv.nix
    ../modules/home/fish.nix
    ../modules/home/git.nix
    ../modules/home/ssh.nix
    ../modules/home/vscode.nix
  ];

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
  };

  home.packages = with pkgs; [
    dig
    jq
    yq-go
    mpv
    neofetch
    hugo # For my website.
    grpcurl
    # LaTeX and TexLive
    texlive.combined.scheme-basic
    yt-dlp
  ];
}
