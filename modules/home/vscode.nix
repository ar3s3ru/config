{ config, pkgs, ... }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  bufbuild.vscode-buf = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bufbuild";
      name = "vscode-buf";
      version = "0.8.13";
      sha256 = "sha256-4BTqir/tNKI5YeKKHjsuMwXWCdADJnCIf5o8IYbGTyY=";
    };
  };

  mrmlnc.vscode-json5 = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "mrmlnc";
      name = "vscode-json5";
      version = "1.0.0";
      sha256 = "XJmlUuKiAWqzvT7tawVY5NHsnUL+hsAjJbrcmxDe8C0=";
    };
  };

  drblury.protobuf-vsc = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "drblury";
      name = "protobuf-vsc";
      version = "1.6.0";
      sha256 = "sha256-HvTJSFRKO0K7Ud9381viPrXp3TInB1FT97qZArosAjY=";
    };
  };

  a-h.templ = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "a-h";
      name = "templ";
      version = "0.0.35";
      sha256 = "WIBJorljcnoPUrQCo1eyFb6vQ5lcxV0i+QJlJdzZYE0=";
    };
  };
in
{
  # NOTE: many of the required packages here are acutally installed already in nvim module.
  # If you can't find something here, look for it there.
  home.packages = with pkgs; [
    nixpkgs-fmt # Used by the nixos extension to format *.nix files.
    nil # Used by nixos extension for autocompletion.
  ];

  programs.vscode.enable = true;
  programs.vscode.mutableExtensionsDir = true;

  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    ms-python.python
    ms-python.pylint
    ms-python.flake8
    ms-python.black-formatter
    ms-python.isort
    tamasfe.even-better-toml
    eamodio.gitlens
    golang.go
    hashicorp.terraform
    hashicorp.hcl
    jnoortheen.nix-ide
    mechatroner.rainbow-csv
    rust-lang.rust-analyzer
    yzhang.markdown-all-in-one
    esbenp.prettier-vscode
    bradlc.vscode-tailwindcss
    dbaeumer.vscode-eslint
    jnoortheen.nix-ide
    mkhl.direnv
    redhat.vscode-yaml
    jock.svg
    editorconfig.editorconfig
    jebbs.plantuml
    mrmlnc.vscode-json5
    bazelbuild.vscode-bazel
    ms-vsliveshare.vsliveshare
    # Local derivation modules
    bufbuild.vscode-buf
    drblury.protobuf-vsc
    mrmlnc.vscode-json5
    a-h.templ
  ];

  programs.vscode.profiles.default.userSettings = {
    "editor.rulers" = [ 80 120 ];
    "editor.fontFamily" = "'Font Awesome','Terminus (TTF)','monospace',monospace,'Droid Sans Mono','Droid Sans Fallback'";
    "editor.formatOnSave" = true;
    "editor.formatOnPaste" = true;
    "editor.suggestSelection" = "first";
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;

    "security.workspace.trust.untrustedFiles" = "open";

    # Golang configuration.
    "go.toolsManagement.autoUpdate" = false;
    "[go]" = { "editor.defaultFormatter" = "golang.go"; };
    "go.lintTool" = "golangci-lint";
    "go.alternateTools" = {
      "dlv" = "${pkgs.delve}/bin/dlv";
      "go" = "${config.programs.go.package}/bin/go";
      "gopls" = "${pkgs.gopls}/bin/gopls";
    };
    "gopls" = {
      "ui.semanticTokens" = true;
      "formatting.gofumpt" = true;
    };

    "[json|jsonc]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };

    # Protobuf configuration.
    "[proto][proto3]" = {
      "editor.defaultFormatter" = "bufbuild.vscode-buf";
    };

    # Markdown configuration.
    "markdown.extension.toc.omittedFromToc" = { };

    # Nix configuration.
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.serverSettings" = {
      "nil" = {
        "formatting" = {
          "command" = [ "nixpkgs-fmt" ];
        };
      };
    };

    # Configuration from ./hosts/default.nix
    "plantuml.server" = "http://127.0.0.1:10808";
    "plantuml.render" = "PlantUMLServer";

    "yaml.format.enable" = true;
  };
}
