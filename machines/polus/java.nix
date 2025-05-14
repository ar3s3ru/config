{ pkgs, ... }:
let
  java = pkgs.jdk23;
in
{
  # NOTE: nixpkgs has a very outdated version of Intellij IDEA,
  # so that's installed as a .dmg from Jetbrains upstream.
  environment.systemPackages = with pkgs; [
    java
    maven
  ];

  environment.variables."JAVA_HOME" = "${java}/zulu-23.jdk/Contents/Home";
}
