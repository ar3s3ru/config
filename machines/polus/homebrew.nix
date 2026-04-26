{
  # Make Homebrew binaries runnable.
  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # "zap" removes manually installed brews and casks
    };

    brews = [
      "awscli@2"
      "poetry"
      "uv"
      "skaffold"
      "k3d"
    ];

    casks = [
      "whatsapp"
      "stats"
      "firefox"
    ];
  };
}
