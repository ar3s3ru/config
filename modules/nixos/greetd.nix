{ config, lib, ... }:

{
  services.greetd.enable = true;
  services.greetd.settings.initial_session = { command = "sway"; };
  services.greetd.settings.default_session = { command = "sway"; };

  environment.etc."greetd/environments".text = ''
    ${lib.optionalString config.programs.sway.enable "sway"}
    ${lib.optionalString config.programs.fish.enable "fish"}
  '';
}
