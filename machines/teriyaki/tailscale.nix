{ ... }:

{
  # NOTE(ar3s3ru): the service packaged here doesn't really work well...
  # Right now, I'm using the App Store rollout.
  #
  # services.tailscale.enable = false;
  # services.tailscale.overrideLocalDns = false;
  networking.knownNetworkServices = [ "Wi-Fi" "iPhone USB" ];
}
