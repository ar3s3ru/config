{ pkgs, ... }:

{
  system.stateVersion = 4;
  ids.gids.nixbld = 350;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  nix.settings.trusted-users = [ "root" "ar3s3ru" "@wheel" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    ripgrep
    # NOTE: git is also set up in Home Manager, but I'm keeping it here
    # so that I can also clone stuff without having a configured user
    # necessarily.
    git
    git-crypt
    gopass
    gopass-jsonapi
    gnumake
    killall
    plantuml
    graphviz
    unzip
    colima
  ];

  # Enable GnuPG Agent.
  # Please note, the actual agent config (e.g. pinentry)
  # is part of modules/gpg-darwin.nix.
  programs.gnupg.agent.enable = true;

  # NOTE: this is not working
  # security.pam.enableSudoTouchIdAuth = true;

  # QoL: Mac key mapping is confusing AF, make it more like Linux.
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.swapLeftCommandAndLeftAlt = true;

  # Enable fish shell globally, but configuration is in the Home Manager flake.
  environment.shells = [ pkgs.fish ];

  users.users.ar3s3ru = {
    home = "/Users/ar3s3ru";
    shell = "${pkgs.fish}/bin/fish";
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  # TODO enable
  # system.defaults.NSGlobalDomain = {
  #   InitialKeyRepeat = 33; # unit is 15ms, so 500ms
  #   KeyRepeat = 2; # unit is 15ms, so 30ms
  #   NSDocumentSaveNewDocumentsToCloud = false;
  # };

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.terminess-ttf
  ];
}
