# modules/nixos/desktop/audio.nix
# Audio configuration with PipeWire
{
  pkgs,
  ...
}:
{
  # Disable PulseAudio (we use PipeWire)
  services.pulseaudio.enable = false;

  # Enable PipeWire
  services.pipewire = {
    enable = true;

    # ALSA support
    alsa = {
      enable = true;
      support32Bit = true;
    };

    # PulseAudio compatibility
    pulse.enable = true;

    # JACK support (for pro audio applications)
    jack.enable = true;

    # WirePlumber session manager
    wireplumber = {
      enable = true;

      # Better Bluetooth audio codecs
      extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.headset-roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
          "bluez5.codecs" = [
            "sbc"
            "sbc_xq"
            "aac"
            "ldac"
            "aptx"
            "aptx_hd"
          ];
        };
      };
    };
  };

  # Real-time audio (required for JACK and low-latency audio)
  security.rtkit.enable = true;

  # Audio packages
  environment.systemPackages = with pkgs; [
    # PipeWire tools
    pwvucontrol # PipeWire volume control
    helvum # PipeWire patchbay

    # Audio utilities
    pavucontrol # PulseAudio volume control (works with PipeWire)
    easyeffects # Audio effects
  ];
}
