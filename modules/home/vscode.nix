{ config, pkgs, ... }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  bazelbuild.vscode-bazel = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bazelbuild";
      name = "vscode-bazel";
      version = "0.8.1";
      sha256 = "VbFbFi77hTBJtXXI+jdp5l8wMIRx0UrXt5tXHs3xaDE=";
    };
  };

  bufbuild.vscode-buf = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bufbuild";
      name = "vscode-buf";
      version = "0.5.3";
      sha256 = "ZfwTj6S54H0ympdjc4/3xBwlvR7zg4vJ98gyVwL8ZRw=";
    };
  };

  fwcd.kotlin = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "fwcd";
      name = "kotlin";
      version = "0.2.34";
      sha256 = "03F6cHIA9Tx8IHbVswA8B58tB8aGd2iQi1i5+1e1p4k=";
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
    tamasfe.even-better-toml
    eamodio.gitlens
    golang.go
    hashicorp.terraform
    jnoortheen.nix-ide
    mechatroner.rainbow-csv
    rust-lang.rust-analyzer
    zxh404.vscode-proto3
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
    # ms-vsliveshare.vsliveshare
    # Local derivation modules
    bufbuild.vscode-buf
    bazelbuild.vscode-bazel
    fwcd.kotlin
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
    "[proto]" = { "editor.defaultFormatter" = "bufbuild.vscode-buf"; };
    "[proto3]" = { "editor.defaultFormatter" = "bufbuild.vscode-buf"; };

    # Markdown configuration.
    "markdown.extension.toc.omittedFromToc" = { };

    # Nix configuration.
    "nix.enableLanguageServer" = true;

    # Configuration from ./hosts/default.nix
    "plantuml.server" = "http://127.0.0.1:10808";
    "plantuml.render" = "PlantUMLServer";

    # These are for CloudFormation.
    "yaml.customTags" = [
      "!And"
      "!If"
      "!Not"
      "!Equals"
      "!Or"
      "!FindInMap sequence"
      "!Base64"
      "!Cidr"
      "!Ref"
      "!Sub"
      "!GetAtt"
      "!GetAZs"
      "!ImportValue"
      "!Select"
      "!Select sequence"
      "!Split"
      "!Join sequence"
    ];
    "yaml.format.enable" = true;
  };
}
