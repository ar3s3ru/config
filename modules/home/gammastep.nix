{ ... }:

{
  services.gammastep = {
    enable = true;

    # Berlin, Mitte
    latitude = 52.531677;
    longitude = 13.381777;

    temperature = {
      day = 6500;
      night = 3500;
    };
  };
}
