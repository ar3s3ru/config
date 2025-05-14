{
  home-manager.users.ar3s3ru =
    { pkgs, lib, config, ... }:
    let
      font = "MesloLGSDZ Nerd Font";
    in
    {
      imports = [
        ../../../../users/ar3s3ru.nix
        ../../../../modules/home/gpg-darwin.nix
        ./picnic-aws.nix
        ./picnic-java.nix
        ./picnic-python.nix
      ];

      # Machine secrets.
      sops.defaultSopsFile = ./secrets.yaml;
      sops.defaultSopsFormat = "yaml";

      sops.secrets."id_25519" = {
        owner = "ar3s3ru";
      };

      home.file.".ssh/id_25519".path = config.sops.secrets."id_25519".path;
      home.file.".ssh/id_25519.pub".source = ./id_25519.pub;

      programs.alacritty.settings.font.normal.family = font;

      programs.vscode.profiles.default.userSettings = {
        "editor.fontFamily" = lib.mkForce "'${font}'";
        "editor.fontSize" = 14;
      };

      home.packages = with pkgs; [
        nodejs
        nodejs.pkgs.pnpm
        just # picnic-fca uses that for some projects.
        libxml2 # For xmllint.
        xmlstarlet
      ];
    };
}
