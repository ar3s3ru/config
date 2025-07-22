{ pkgs, colorscheme, ... }:

{
  services.mako = with colorscheme.palette; {
    enable = true;

    font = "MesloLGS NF 10";
    maxIconSize = 32;
    padding = "10,20";
    defaultTimeout = 8000;
    width = 400;
    height = 150;
    borderSize = 1;

    backgroundColor = "#${base00}";
    textColor = "#${base05}";
    borderColor = "#${base0D}";

    extraConfig = /* ini */ ''
      [urgency=low]
      background-color=#${base00}
      text-color=#${base0A}
      border-color=#${base0D}

      [urgency=high]
      background-color=#${base00}
      text-color=#${base08}
      border-color=#${base0D}
    '';
  };

  systemd.user.services.mako = {
    Unit.PartOf = [ "sway-session.target" ];
    Install.WantedBy = [ "sway-session.target" ];

    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };
  };
}
