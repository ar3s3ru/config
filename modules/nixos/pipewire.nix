{
  # Pipewire with bluetooth support.
  # Copied from https://nixos.wiki/wiki/PipeWire
  #
  # Context: https://github.com/NixOS/nixpkgs/commit/1fab86929f7df5cdd60bcf65b4c78f4058777a03
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;

  services.pipewire.alsa = {
    enable = true;
    support32Bit = true;
  };
}
