{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    poetry
  ];

  sops.secrets.poetry-config = {
    mode = "0440";
    path = "${config.home.homeDirectory}/Library/Application Support/pypoetry/auth.toml";
  };
}
