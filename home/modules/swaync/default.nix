{ pkgs, colorscheme, ... }:
let
  fontFamily = "MesloLGS NF";
in
{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];


  wayland.windowManager.sway.extraConfig = ''
    exec_always ${pkgs.swaynotificationcenter}/bin/swaync
  '';

  xdg.configFile."swaync/config.json".source = ./config.json;
  xdg.configFile."swaync/style.css".text = with colorscheme.palette; ''
    @define-color cc-bg               #${base00};
    @define-color actual-noti-bg      #${base00};
    @define-color mpris-player-bg     rgba(38, 37, 39, 0.25);
    @define-color noti-close-bg-hover rgba(38, 37, 39, 0.2);
    @define-color noti-action-bg      #${base01};
    @define-color noti-center-border  #${base05};
    @define-color noti-close-bg       transparent;
    @define-color noti-bg             transparent;
    @define-color noti-bg-darker      transparent;
    @define-color noti-bg-hover       #${base01};
    @define-color noti-bg-focus       transparent;
    @define-color text-color          #${base06};
    @define-color text-color-disabled #69676C;
    @define-color noti-border-color   #${base05};
    @define-color bg-selected         #${base01};

    .notification {
      font-family: ${fontFamily};
      border-radius: 15px;
      box-shadow: none;
      border: 3px solid @noti-border-color;
      background: @actual-noti-bg;
    }

    .notification-content {
      padding: 5px 8px;
    }

    /* align floating notifications with borders of hyprland clients */
    .notification-row:first-child {
      margin-top: 7px;
    }

    .notification-group {
      outline: none;
    }

    .image {
      border-radius: 10px;
    }

    .notification-group.collapsed .notification-row:not(:last-child) .notification {
      transition: opacity 250ms;
      opacity: 0.25;
    }

    .notification *,
    .control-center .notification,
    .notification-row:focus,
    .notification-row:hover,
    .blank-window {
      background: transparent;
    }

    .notification-default-action,
    .notification-action {
      border: none;
    }

    .notification-action:not(:last-child) {
      margin-right: 3px;
    }

    .notification-action {
      border-radius: 10px;
      background: @noti-action-bg;
    }

    .time {
      font-size: 15px;
      background: transparent;
      margin-right: 15px;
    }

    .control-center {
      font-family: ${fontFamily};
      border-left: 3px solid @noti-center-border;
      border-right: 3px solid @noti-center-border;
      border-radius: 0;
    }

    .control-center-list-placeholder {
      opacity: 0.8;
    }

    .widget-title {
      margin: 20px 15px 5px 15px;
      font-size: 30px;
    }
    .widget-title > button {
      font-size: 15px;
      background: transparent;
      border: none;
      border-radius: 10px;
    }
    .widget-title > button:hover {
      background: @noti-close-bg-hover;
    }

    .widget-mpris-player {
      padding: 8px;
      box-shadow: none;
      background: @mpris-player-bg;
    }
    .widget-mpris-player button {
      background: transparent;
    }
  '';
}
