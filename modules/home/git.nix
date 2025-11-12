{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [
    gh
  ];

  programs.git.enable = true;
  programs.git.settings.user.name = "Danilo Cianfrone";
  programs.git.settings.user.email = "danilocianfr@gmail.com";
  programs.git.settings.core.editor = "nvim";
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.commit.gpgSign = true;
  programs.git.settings.tag.gpgSign = true;
  programs.git.settings.push.autoSetupRemote = true;
  programs.git.settings.credential."https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
}
