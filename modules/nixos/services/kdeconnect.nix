# modules/nixos/services/kdeconnect.nix
# KDE Connect configuration
# Note: Most KDE Connect setup is in plasma.nix
# This module handles additional service configuration
{
  ...
}:
{
  # KDE Connect is enabled in plasma.nix via programs.kdeconnect.enable

  # Firewall rules for KDE Connect are in networking.nix
  # Ports 1714-1764 TCP/UDP

  # KDE Connect GSConnect integration for GNOME (if ever needed)
  # programs.gnome.gnome-remote-desktop.enable = true;
}
