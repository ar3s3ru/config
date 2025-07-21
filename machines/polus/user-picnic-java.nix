{ pkgs, config, ... }:

{
  programs.java.enable = true;
  programs.java.package = pkgs.jdk21_headless;

  home.packages = with pkgs; [
    maven
  ];

  programs.fish.shellAliases = {
    mvnc = "mvn --batch-mode --define surefire.timeout=300 --define rabbitmq.support-delays=false -Dstyle.color=always -Prelaxed-release\\$";
    mvni = "mvnc install";
  };

  sops.secrets.nexus-password = { };

  home.sessionVariables."NEXUS_USERNAME" = "dcianfrone";
  programs.fish.shellInit = ''
    set -gx NEXUS_PASSWORD (cat ${config.sops.secrets.nexus-password.path})
  '';

  sops.secrets.maven-settings = {
    mode = "0440";
    path = "${config.home.homeDirectory}/.m2/settings.xml";
  };

  home.file."maven-jvm-config" = {
    executable = false;
    target = ".mvn/jvm.config";
    # Source: https://errorprone.info/docs/installation#maven
    text = ''
      --add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED
      --add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED
      --add-opens jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED
      --add-opens jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED
    '';
  };
}
