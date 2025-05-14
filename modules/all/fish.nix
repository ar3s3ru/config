{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fzf
    bat
    duf
    eza
    prettyping
    htop
    grc
    # Fish plugins
    # fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.grc
  ];

  programs.fish.enable = true;
  programs.fish.shellAliases = {
    cat = "bat";
    du = "duf";
    ls = "eza";
    top = "htop";
    ping = "prettyping --nolegend";
  };
}
