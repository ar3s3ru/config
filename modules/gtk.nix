{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gthumb
    gnome.nautilus
    gnome.file-roller
    commonsCompress
  ];

  gtk = {
    enable = true;
    font.name = "sans-serif 10";

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };

    iconTheme = {
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
    };

    # Tooltips remain visible when switching to another workspace
    gtk2.extraConfig = ''
      gtk-enable-tooltips = 0
    '';

    gtk3.bookmarks = [
      "file:///tmp"
    ];
  };
}
