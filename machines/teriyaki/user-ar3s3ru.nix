{ lib, pkgs, ... }:
let
  font = "MesloLGSDZ Nerd Font";
in
{
  imports = [
    ../../modules/darwin/gpg.nix
    ../../users/ar3s3ru.nix
  ];

  programs.alacritty.settings.font.normal.family = font;

  programs.vscode.profiles.default.userSettings = {
    "editor.fontFamily" = lib.mkForce "'${font}'";
    "editor.fontSize" = 14;
  };

  home.packages = with pkgs; [
    nodejs
    nodejs.pkgs.pnpm
  ];
}
