{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    poetry
  ];

  sops.secrets."picnic-poetry-auth-settings" = {
    owner = "ar3s3ru";
  };

  home.file."poetry-config" = {
    executable = false;
    target = "Library/Application Support/pypoetry/auth.toml";
    path = config.sops.secrets."picnic-poetry-auth-settings".path;
  };
}
