# modules/nixos/services/default.nix
# Imports all service modules
{
  imports = [
    ./tailscale.nix
    ./kdeconnect.nix
    ./virtualization.nix
  ];
}
