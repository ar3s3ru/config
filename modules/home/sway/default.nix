{ config, lib, pkgs, colorscheme, wallpaper, ... }:
let
  cfg = config.wayland.windowManager.sway.config;

  # Map to workspace index (num pad keys) to name.
  workspaces = [
    { index = "1"; name = "\"1: term\""; }
    { index = "2"; name = "\"2: www\""; }
    { index = "3"; name = "\"3: code\""; }
    { index = "4"; name = "\"4: ide\""; }
    { index = "5"; name = "\"5: chat\""; }
    { index = "6"; name = "6"; }
    { index = "7"; name = "7"; }
    { index = "8"; name = "8"; }
    { index = "9"; name = "9"; }
    { index = "0"; name = "\"10: slack\""; }
  ];

  laptopScreenId = "eDP-1";
  clamshellScript = ./clamshell.sh;
in
{
  home.sessionVariables = {
    # Java acts like a bit of a bitch on Wayland, these settings
    # are required for Java-based UIs.
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
  };

  home.packages = with pkgs; [
    pavucontrol
    brightnessctl # To control the screen brightness.
    libnotify # Send notifications through notify-send.
    findutils # To use xargs in the menu section.
    playerctl # To control sounds using the media keys.
    swaylock # To lock the screen.
    wl-clipboard # For wl-paste and wl-copy utilities.
    grim # Take screenshots
    swaynotificationcenter # Sends notifications
    wdisplays # For screen arrangement

    # NOTE: if you need Chromium, this is how you should do it!
    # Make sure to enable the WebRTC Pipewire Capturer flag for screensharing!
    # (chromium.override {
    #   commandLineArgs = [
    #     "--enable-features=UseOzonePlatform"
    #     "--ozone-platform=wayland"
    #   ];
    # })
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  wayland.windowManager.sway = {
    enable = true;

    # XWayland makes Sway work with legacy apps that use X.org
    xwayland = true;

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    # Set up the clamshell mode.
    # More info here: https://github.com/swaywm/sway/wiki#clamshell-mode
    extraConfig = ''
      bindswitch --reload --locked lid:on output ${laptopScreenId} disable
      bindswitch --reload --locked lid:off output ${laptopScreenId} enable
    '';

    config.startup = [{
      always = true;
      command = "${clamshellScript} ${laptopScreenId}";
    }];

    # General configuration.
    config = {
      left = "j";
      right = "l";
      up = "i";
      down = "k";

      modifier = lib.mkDefault "Mod4";
      terminal = lib.mkDefault "${pkgs.alacritty}/bin/alacritty";
      menu = "rofi -show run | ${pkgs.findutils}/bin/xargs ${pkgs.sway}/bin/swaymsg exec";

      fonts = {
        names = [ "Terminus" ];
        size = 10.0;
      };

      window.border = 2;

      gaps = {
        inner = 5;
        outer = 10;
      };

      # Use waybar instead of the default swaybar.
      bars = [ ];

      # Set the background.
      #
      # TODO: find a way to parametrize the wallpaper name, ideally coming
      # from the xdg.configFile invocation up above.
      output."*".bg = "${wallpaper} fill";

      # TODO: this section might be improved by categorizing types of input?
      input = {
        "*" = {
          xkb_layout = "us";
          xkb_model = "pc105";
          xkb_variant = "intl";

          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          middle_emulation = "enabled";
        };
      };

      keybindings = {
        "${cfg.modifier}+Shift+q" = "kill";
        "${cfg.modifier}+p" = "exec ${cfg.menu}";
        "${cfg.modifier}+Shift+c" = "reload";
        "${cfg.modifier}+Shift+e" = "exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' '${pkgs.sway}/bin/swaymsg exit'";

        # Utilities
        # -- Start a new terminal.
        "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
        # -- Lock the screen.
        "${cfg.modifier}+Ctrl+q" = "exec fish -c '${pkgs.swaylock}/bin/swaylock -f -d -c (echo \'${colorscheme.palette.base00}\' | sed \'s/\\#//\')'";
        # -- Hibernate the system.
        "${cfg.modifier}+Ctrl+h" = "exec fish -c 'notify-send \"Hibernating...\" \"The system is about to go into hibernation.\" && systemctl hibernate'";
        # -- Shutdown the system.
        "${cfg.modifier}+Ctrl+s" = "exec fish -c 'notify-send \"Shutting down...\" \"The system is shutting down.\" && systemctl poweroff'";

        # Pulseaudio controls
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";

        # Screen brightness control
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

        # Media player controls
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl prev";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";

        # Screen capture
        "--release Print" = "exec grim \"${config.home.homeDirectory}/Screenshots/$(date --iso-8601=seconds).png\"";

        # Moving around
        "${cfg.modifier}+${cfg.left}" = "focus left";
        "${cfg.modifier}+${cfg.down}" = "focus down";
        "${cfg.modifier}+${cfg.up}" = "focus up";
        "${cfg.modifier}+${cfg.right}" = "focus right";

        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        "${cfg.modifier}+Shift+${cfg.left}" = "move left";
        "${cfg.modifier}+Shift+${cfg.down}" = "move down";
        "${cfg.modifier}+Shift+${cfg.up}" = "move up";
        "${cfg.modifier}+Shift+${cfg.right}" = "move right";

        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";

        # Splits
        "${cfg.modifier}+b" = "splith";
        "${cfg.modifier}+v" = "splitv";

        # Layouts
        "${cfg.modifier}+s" = "layout stacking";
        "${cfg.modifier}+w" = "layout tabbed";
        "${cfg.modifier}+e" = "layout toggle split";
        "${cfg.modifier}+f" = "fullscreen toggle";

        "${cfg.modifier}+a" = "focus parent";

        "${cfg.modifier}+Shift+space" = "floating toggle";
        "${cfg.modifier}+space" = "focus mode_toggle";

        # Scratchpad
        "${cfg.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.modifier}+minus" = "scratchpad show";

        # Resize mode
        "${cfg.modifier}+r" = "mode resize";

        # Map workspaces using the custom map at the top
      } // (lib.foldl lib.recursiveUpdate { } (map
        (workspace: {
          "${cfg.modifier}+${workspace.index}" = "workspace ${workspace.name}";
          "${cfg.modifier}+Shift+${workspace.index}" = "move container to workspace ${workspace.name}";
        })
        workspaces));

      colors = with colorscheme.palette; {
        focused = {
          border = "#${base05}";
          background = "#${base05}";
          text = "#${base00}";
          indicator = "#${base05}";
          childBorder = "#${base05}";
        };

        focusedInactive = {
          border = "#${base01}";
          background = "#${base01}";
          text = "#${base05}";
          indicator = "#${base03}";
          childBorder = "#${base05}";
        };

        unfocused = {
          border = "#${base01}";
          background = "#${base00}";
          text = "#${base05}";
          indicator = "#${base01}";
          childBorder = "#${base01}";
        };

        urgent = {
          border = "#${base08}";
          background = "#${base08}";
          text = "#${base00}";
          indicator = "#${base08}";
          childBorder = "#${base08}";
        };

        placeholder = {
          border = "#${base00}";
          background = "#${base00}";
          text = "#${base05}";
          indicator = "#${base00}";
          childBorder = "#${base00}";
        };
      };
    };
  };
}
