{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gthumb
    nautilus
    file-roller
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
      package = pkgs.adwaita-icon-theme;
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
