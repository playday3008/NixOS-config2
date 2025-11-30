# modules/nixos/hardware/bluetooth.nix
# Bluetooth configuration
{
  ...
}:
{
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        # Modern Bluetooth features
        Enable = "Source,Sink,Media,Socket";

        # Fast connect
        FastConnectable = true;

        # Experimental features for better codec support
        Experimental = true;
      };
    };
  };

  # Bluetooth manager service
  services.blueman.enable = true;

  # Better Bluetooth audio (handled by PipeWire)
  # This is configured in audio.nix
}
