{ config, ... }:

{
  sops.secrets.opencode-auth-json = {
    mode = "0600";
    format = "json";
    sopsFile = ./auth.enc.json;
    path = "${config.home.homeDirectory}/.local/share/opencode/auth.json";
  };

  home.file."opencode-json" = {
    executable = false;
    target = ".config/opencode/opencode.json";
    source = ./opencode.json;
  };

  sops.secrets.github-token = { sopsFile = ./credentials.enc.json; };
  sops.secrets.terraform-token = { sopsFile = ./credentials.enc.json; };

  home.sessionVariables = {
    OPENCODE_MCP_GITHUB_TOKEN = config.sops.secrets.github-token.path;
    OPENCODE_MCP_TERRAFORM_TFE_TOKEN = config.sops.secrets.terraform-token.path;
  };
}
