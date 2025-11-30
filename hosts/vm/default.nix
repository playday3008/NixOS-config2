# hosts/vm/default.nix
# Virtual machine configuration for testing
{
  lib,
  ...
}:
{
  imports = [
    # Hardware configuration
    ./hardware.nix
    ./disko.nix

    # Desktop environment
    ../../modules/nixos/desktop

    # Hardware modules (minimal for VM)
    ../../modules/nixos/hardware

    # System programs
    ../../modules/nixos/programs

    # System services
    ../../modules/nixos/services

    # Security modules
    ../../modules/nixos/security
  ];

  # Timezone
  time.timeZone = "UTC";

  # VM-specific settings
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Disable fingerprint in VM
  security.pam.services = {
    login.fprintAuth = lib.mkForce false;
    sudo.fprintAuth = lib.mkForce false;
    sddm.fprintAuth = lib.mkForce false;
  };
}
