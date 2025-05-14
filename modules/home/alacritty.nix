{ lib, colorscheme, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };

      window.opacity = lib.mkDefault 0.9;

      font = {
        size = lib.mkDefault 12;
        normal.family = lib.mkDefault "Terminus";
      };

      colors = with colorscheme; {
        primary = {
          background = "0x${palette.base00}";
          foreground = "0x${palette.base05}";
        };

        cursor = {
          text = "0x${palette.base00}";
          cursor = "0x${palette.base05}";
        };

        normal = {
          black = "0x${palette.base00}";
          red = "0x${palette.base08}";
          green = "0x${palette.base0B}";
          yellow = "0x${palette.base0A}";
          blue = "0x${palette.base0D}";
          magenta = "0x${palette.base0E}";
          cyan = "0x${palette.base0C}";
          white = "0x${palette.base05}";
        };

        # Bright colors
        bright = {
          black = "0x${palette.base03}";
          red = "0x${palette.base08}";
          green = "0x${palette.base0B}";
          yellow = "0x${palette.base0A}";
          blue = "0x${palette.base0D}";
          magenta = "0x${palette.base0E}";
          cyan = "0x${palette.base0C}";
          white = "0x${palette.base07}";
        };
      };
    };
  };
}
