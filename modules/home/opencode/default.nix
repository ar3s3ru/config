{ config, ... }:

{
  sops.secrets.opencode-auth-json = {
    mode = "0600";
    format = "json";
    key = ""; # Entire file!
    sopsFile = ./auth.enc.json;
    path = "${config.home.homeDirectory}/.local/share/opencode/auth.json";
  };

  sops.secrets.github-token = {
    mode = "0400";
    sopsFile = ./credentials.enc.json;
    path = "${config.home.homeDirectory}/.local/share/opencode/github-token";
  };

  sops.secrets.terraform-token = {
    mode = "0400";
    sopsFile = ./credentials.enc.json;
    path = "${config.home.homeDirectory}/.local/share/opencode/terraform-tfe-token";
  };

  home.file."opencode-json" = {
    executable = false;
    target = ".config/opencode/opencode.json";
    source = ./opencode.json;
  };
}
