# hosts/vm/hardware.nix
# Virtual machine hardware configuration
{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Kernel modules for VM
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  boot.kernelModules = [ ];

  # Use virtio GPU
  services.xserver.videoDrivers = [ "virtio" ];
}
