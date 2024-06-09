{ pkgs, ... }:

{
  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = "experimental-features = nix-command flakes";
}
