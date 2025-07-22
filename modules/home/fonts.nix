{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    meslo-lgs-nf

    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji

    nerd-fonts.terminess-ttf
    terminus_font
    # terminus_font_ttf
    papirus-icon-theme
    font-awesome

    # Use a font viewer to check that shit is working properly.
    gnome-font-viewer
  ];
}
