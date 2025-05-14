{ config, ... }:

{
  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "danilocianfr+letsencrypt@gmail.com";
      server = "https://acme-v02.api.letsencrypt.org/directory";
      group = config.services.nginx.group;
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/acme/environment"; # NOTE: this file must be added manually!
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
    };
  };

  services.nginx = {
    enable = true;

    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    commonHttpConfig = ''
      log_format myformat '$remote_addr - $remote_user [$time_local] '
                          '"$request" $status $body_bytes_sent '
                          '"$http_referer" "$http_user_agent"';
    '';
  };
}
