# modules/nixos/security/default.nix
# Imports all security modules
{
  imports = [
    ./sops.nix
  ];
}
