{
  homebrew.brews = [ "docker" "colima" "docker-compose" ];

  environment.variables = {
    DOCKER_HOST = "unix:///Users/ar3s3ru/.colima/docker.sock";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
  };
}
