{ config, ... }:

{
  sops.secrets."picnic-awsconfig" = {
    owner = "ar3s3ru";
  };

  home.file.".aws/config".path = config.sops.secrets."picnic-awsconfig".path;
}
