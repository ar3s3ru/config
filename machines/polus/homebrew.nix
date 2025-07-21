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
    ];

    casks = [
      "whatsapp"
      "stats"
      "firefox"
    ];
  };
}
