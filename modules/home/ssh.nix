{ config, ssh, ... }:

{
  programs.ssh = {
    enable = true;
  };

  sops.secrets.id_ed25519.path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  home.file.".ssh/id_ed25519.pub".source = ssh.public-key;
}
