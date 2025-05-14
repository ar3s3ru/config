{ lib, pkgs, ... }:
let
  teriyaki-ssh-key = lib.readFile ../../machines/teriyaki/id_ed25519.pub;
in
{
  # Users creation can only be controlled through this configuration.
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users.root.hashedPassword = "$6$IAwKbqRXgvJXNTPI$w8m6U48i5j9kCG9GoMSgeUC5XzIrxz9IA.8EmV91bZdlM.B82zI2.wdxR6SD.U8xBPlm3nIgtJGUvWChD.yYX/";
  users.users.root.openssh.authorizedKeys.keys = [ teriyaki-ssh-key ];
}
