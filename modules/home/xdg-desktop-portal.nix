{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    slurp
  ];

  # Screen recording/sharing with Pipewire.
  # xdg-desktop-portal is installed in system configuration.
  xdg.configFile."xdg-desktop-portal-wlr/config".text = lib.generators.toINI { } {
    screencast = {
      # max_fps = 30;
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };
}
