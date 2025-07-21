{ lib, pkgs, ... }:
let
  font = "MesloLGSDZ Nerd Font";
in
{
  imports = [
    ../../home/ar3s3ru
    ../../modules/darwin/gpg.nix
    ./user-picnic-aws.nix
    ./user-picnic-java.nix
    ./user-picnic-kube.nix
    ./user-picnic-python.nix
  ];

  programs.alacritty.settings.font.normal.family = font;

  programs.vscode.profiles.default.userSettings = {
    "editor.fontFamily" = lib.mkForce "'${font}'";
    "editor.fontSize" = 14;
  };

  sops.age.keyFile = "/Users/ar3s3ru/.config/sops/age/keys.txt";

  home.packages = with pkgs; [
    nodejs
    nodejs.pkgs.pnpm
    just # picnic-fca uses that for some projects
    libxml2 # For xmllint
    xmlstarlet
    marp-cli # For Tech Horizons
  ];
}
