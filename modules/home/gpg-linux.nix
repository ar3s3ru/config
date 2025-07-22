{ pkgs, ... }:
let
  pinentryPackage = pkgs.pinentry-gnome3;
in
{
  home.packages = [ pinentryPackage ];

  # NOTE: GTK+3 is not working well for some reason...
  # Swithcing back to GTK+2 for the time being.
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pinentryPackage;
}
