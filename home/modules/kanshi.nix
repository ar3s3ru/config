{ ... }:

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
  ];
}
