# hosts/framework/hardware.nix
# Framework Laptop 16 hardware configuration
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel modules
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [
    "kvm-amd"
  ];

  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable firmware updates
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # Ambient light sensor support
  # Framework Laptop 16 has an ambient light sensor
  hardware.sensor.iio.enable = true;

  # Power management - PPD is recommended for Framework
  # (nixos-hardware enables this, but we set it explicitly)
  services.power-profiles-daemon.enable = true;

  # Disable TLP (conflicts with PPD)
  services.tlp.enable = false;

  # Battery charge thresholds (optional, requires ectool)
  # Uncomment if you want to limit battery charge to extend lifespan
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="power_supply", ATTR{charge_control_start_threshold}="75"
  #   ACTION=="add", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80"
  # '';

  # Thunderbolt support
  services.hardware.bolt.enable = true;
}
