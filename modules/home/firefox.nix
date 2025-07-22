{ config, pkgs, libs, ... }:
let
  defaultSettings = {
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.quicksuggest.migrationVersion" = "2";
    "browser.search.hiddenOneOffs" = "Google,Amazon.de,Bing";
  };
in
{
  # Run Firefox with Wayland support.
  # Source: https://nixos.wiki/wiki/Firefox
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;

    profiles = {
      "ar3s3ru" = {
        id = 0;
        settings = defaultSettings;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          gopass-bridge
          multi-account-containers
        ];
      };
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
}
