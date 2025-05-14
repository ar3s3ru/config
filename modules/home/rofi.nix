{ config, pkgs, colorscheme, ... }:
let
  # To write strings in the configuration without double quotes.
  inherit (config.lib.formats.rasi) mkLiteral;

  font = "MesloLGS NF 10";
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = font;

    terminal = "${pkgs.alacritty}/bin/alacritty";

    extraConfig = {
      drun-display-format = "{icon} {name}";
      threads = 0;
      scroll-method = 0;
      disable-history = false;
      fullscreen = false;
      run-command = "${pkgs.fish}/bin/fish -i -c '{cmd}'";
    };

    theme = {
      "@import" = "gruvbox-dark.rasi";

      "*" = with colorscheme.palette; {
        red = mkLiteral "#${base08}";
        blue = mkLiteral "#${base0D}";
        lightfg = mkLiteral "#${base06}";
        lightbg = mkLiteral "#${base01}";
        foreground = mkLiteral "#${base05}";
        background = mkLiteral "#${base00}";
        background-color = mkLiteral "#${base00}";
        separatorcolor = mkLiteral "@foreground";
        border-color = mkLiteral "@foreground";
        selected-normal-foreground = mkLiteral "@lightbg";
        selected-normal-background = mkLiteral "@lightfg";
        selected-active-foreground = mkLiteral "@background";
        selected-active-background = mkLiteral "@blue";
        selected-urgent-foreground = mkLiteral "@background";
        selected-urgent-background = mkLiteral "@red";
        normal-foreground = mkLiteral "@foreground";
        normal-background = mkLiteral "@background";
        active-foreground = mkLiteral "@blue";
        active-background = mkLiteral "@background";
        urgent-foreground = mkLiteral "@red";
        urgent-background = mkLiteral "@background";
        alternate-normal-foreground = mkLiteral "@foreground";
        alternate-normal-background = mkLiteral "@lightbg";
        alternate-active-foreground = mkLiteral "@blue";
        alternate-active-background = mkLiteral "@lightbg";
        alternate-urgent-foreground = mkLiteral "@red";
        alternate-urgent-background = mkLiteral "@lightbg";
      };

      prompt = {
        text-color = mkLiteral "@red";
      };

      mainbox = {
        spacing = mkLiteral "1%";
        padding = mkLiteral "1% 1% 1% 1%";
      };

      case-indicator = {
        background-color = "@background";
        text-color = "@foreground";
      };
    };
  };
}
