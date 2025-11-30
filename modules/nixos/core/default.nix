# modules/nixos/core/default.nix
# Imports all core system modules
{
  imports = [
    ./boot.nix
    ./nix.nix
    ./locale.nix
    ./networking.nix
    ./security.nix
    ./users.nix
  ];
}
