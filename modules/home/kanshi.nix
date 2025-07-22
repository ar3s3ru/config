{ pkgs, ... }:

{
  services.kanshi.enable = true;
  services.kanshi.settings = [
    {
      profile.name = "home";
      profile.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.0;
        }
        {
          criteria = "LG Electronics LG HDR 4K 211MAHUMY369";
          scale = 1.25;
        }
      ];
    }
    {
      profile.name = "picnic-3rd-floor-accelerator";
      profile.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.0;
        }
        {
          criteria = "Dell Inc. DELL P2422HE 7ZS59M3";
          scale = 1.0;
        }
      ];
    }
  ];
}
