# modules/nixos/hardware/default.nix
# Imports all hardware modules
{
  imports = [
    ./bluetooth.nix
    ./gpu-amd.nix
    ./power.nix
  ];
}
