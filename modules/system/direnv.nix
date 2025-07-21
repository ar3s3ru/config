{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.shellInit = ''
    direnv hook fish | source
  '';
}
