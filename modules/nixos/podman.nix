{ pkgs, ... }:

{
  # Enable Podman for containers with Docker compatibility.
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.autoPrune.enable = true;

  environment.systemPackages = with pkgs; [
    qemu # QEMU is used for the virtual machine Podman uses under the hood.
    virtiofsd
  ];

  # NOTE(ar3s3ru): this is super hardcoded and maybe doesn't work in another machine.
  # Is this a good idea at all?
  environment.variables."DOCKER_HOST" = "unix:///run/user/1000/podman/podman-machine-default-api.sock";
}
