{ lib, pkgs, colorscheme, ... }:

{
  # Theming using nix-colors and base16 style.
  xdg.configFile."waybar/colors.css".text = with colorscheme.palette; ''
    @define-color base00 #${base00};
    @define-color base01 #${base01};
    @define-color base02 #${base02};
    @define-color base03 #${base03};
    @define-color base04 #${base04};
    @define-color base05 #${base05};
    @define-color base06 #${base06};
    @define-color base07 #${base07};
    @define-color base08 #${base08};
    @define-color base09 #${base09};
    @define-color base0A #${base0A};
    @define-color base0B #${base0B};
    @define-color base0C #${base0C};
    @define-color base0D #${base0D};
    @define-color base0E #${base0E};
    @define-color base0F #${base0F};
  '';

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = lib.readFile ./style.css;

    settings = [{
      layer = "top";
      position = "top";

      modules-left = [
        "sway/workspaces"
        "custom/right-arrow-dark"
      ];
      modules-center = [
        "custom/left-arrow-dark"
        "clock#1"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "clock#2"
        "custom/right-arrow-dark"
        "custom/right-arrow-light"
        "clock#3"
        "custom/right-arrow-dark"
      ];
      modules-right = [
        "custom/left-arrow-dark"
        "pulseaudio"
        # "custom/left-arrow-light"
        # "custom/left-arrow-dark"
        # "custom/spotify"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "network"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "memory"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "cpu"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "battery"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "temperature"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "disk"
        "custom/left-arrow-light"
        "custom/left-arrow-dark"
        "tray"
      ];

      "custom/left-arrow-dark" = {
        format = "";
        tooltip = false;
      };
      "custom/left-arrow-light" = {
        format = "";
        tooltip = false;
      };
      "custom/right-arrow-dark" = {
        format = "";
        tooltip = false;
      };
      "custom/right-arrow-light" = {
        format = "";
        tooltip = false;
      };

      "sway/workspaces" = {
        disable-scroll = true;
        format = "{name}";
      };

      "clock#1" = {
        format = "{:%a}";
        tooltip = false;
      };
      "clock#2" = {
        format = "{:%H:%M}";
        tooltip = false;
      };
      "clock#3" = {
        format = "{:%Y-%m-%d}";
        tooltip = false;
      };

      "pulseaudio" = {
        format = "{icon} {volume:2}%";
        format-bluetooth = "{icon}  {volume}%";
        format-muted = "MUTE";
        format-icons = {
          headphones = "";
          default = [ "" "" ];
        };
        scroll-step = 5;
        on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "custom/spotify" = {
        exec = "spt pb -s";
        format = "{}  ";
        interval = 5;
        on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
        on-scroll-up = "${pkgs.playerctl}/bin/playerctl next";
        on-scroll-down = "${pkgs.playerctl}/bin/playerctl previous";
      };

      "network" = {
        format = "? {ifname}";
        format-wifi = " {essid} ({signalStrength}%)";
        format-ethernet = " {ifname} {ipaddr}";
        format-linked = " {ifname} (no IP)";
        format-disconnected = " Disconnected";
      };

      "memory" = {
        interval = 5;
        format = " {used:0.1f}G/{total:0.1f}G";
      };

      "cpu" = {
        interval = 5;
        format = " {usage:2}%";
      };

      "battery" = {
        states = {
          good = 85;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      "disk" = {
        interval = 5;
        format = " {percentage_used:2}%";
        path = "/";
      };

      "temperature" = {
        thermal-zone = 2;
        hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";

        critical-threshold = 80;
        format-critical = " {temperatureC}°C";
        format = " {temperatureC}°C";
      };

      "tray" = {
        icon-size = 16;
      };
    }];
  };
}
