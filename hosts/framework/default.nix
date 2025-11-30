# hosts/framework/default.nix
# Framework Laptop 16 configuration
{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Hardware configuration
    ./hardware.nix
    ./disko.nix

    # nixos-hardware module for Framework Laptop 16 AMD
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd

    # Desktop environment
    ../../modules/nixos/desktop

    # Hardware modules
    ../../modules/nixos/hardware

    # System programs
    ../../modules/nixos/programs

    # System services
    ../../modules/nixos/services

    # Security modules
    ../../modules/nixos/security
  ];

  # Timezone for this host
  time.timeZone = "Europe/London"; # Change to your timezone

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    # Framework-specific tools
    framework-tool
  ];
}
