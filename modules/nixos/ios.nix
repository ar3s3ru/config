{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Packages needed for mounting iOS devices.
    libimobiledevice
    ifuse
  ];

  # Enable support for mounting iOS devices.
  services.usbmuxd.enable = true;
}
