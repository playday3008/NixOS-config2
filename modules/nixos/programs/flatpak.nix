# modules/nixos/programs/flatpak.nix
# Flatpak support for additional applications
{
  ...
}:
{
  # Enable Flatpak
  services.flatpak.enable = true;

  # Add Flathub repository on activation
  # Run manually after first boot:
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  # XDG portal for Flatpak integration
  xdg.portal = {
    enable = true;
    # Portal backends are set in plasma.nix for KDE
  };

  # Flatpak font/icon cache
  # This ensures Flatpak apps have access to system fonts
  fonts.fontDir.enable = true;
}
