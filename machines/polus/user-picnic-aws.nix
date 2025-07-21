{ config, ... }:

{
  sops.secrets.awsconfig.path = "${config.home.homeDirectory}/.aws/config";
}
