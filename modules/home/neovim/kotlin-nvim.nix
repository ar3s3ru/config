# AlexandrosAlexiou/kotlin.nvim
#
# Extensions for JetBrains' kotlin-lsp in Neovim. Provides:
#   - workspace/configuration handler for the jetbrains.kotlin section
#     (needed for the server's completion subsystem to fully activate).
#   - Per-project --system-path isolation to prevent index lock contention.
#   - Inlay hints, IDEA-style format, organize imports, code actions.
#
# The plugin auto-discovers the kotlin-lsp install via $KOTLIN_LSP_DIR. We
# set that in extraConfigLua to point at our kotlin-lsp.nix derivation's
# $out/share, which contains the layout the plugin expects (bin/intellij-server
# + lib/).
{ vimUtils
, fetchFromGitHub
, lib
}:
vimUtils.buildVimPlugin {
  pname = "kotlin.nvim";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "AlexandrosAlexiou";
    repo = "kotlin.nvim";
    rev = "v1.2.0";
    hash = "sha256-go+f6zVh284bsFc3X5O4mvPXr8l8OqzStcTJEoGNMGk=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Extensions for JetBrains kotlin-lsp in Neovim";
    homepage = "https://github.com/AlexandrosAlexiou/kotlin.nvim";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
}
