# modules/nixos/programs/default.nix
# Imports all program modules
{
  imports = [
    ./flatpak.nix
    ./gaming.nix
  ];
}
