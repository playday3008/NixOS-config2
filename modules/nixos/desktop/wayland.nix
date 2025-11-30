# modules/nixos/desktop/wayland.nix
# Wayland-specific configuration
_:
{
  # Wayland environment variables
  environment.sessionVariables = {
    # Wayland for Qt applications
    QT_QPA_PLATFORM = "wayland;xcb";

    # Wayland for SDL applications
    SDL_VIDEODRIVER = "wayland";

    # Wayland for Clutter applications
    CLUTTER_BACKEND = "wayland";

    # Firefox Wayland
    MOZ_ENABLE_WAYLAND = "1";

    # Electron apps Wayland support
    NIXOS_OZONE_WL = "1";

    # GTK Wayland
    GDK_BACKEND = "wayland,x11";
  };

  # XWayland for legacy X11 applications
  programs.xwayland.enable = true;

  # Enable dconf for GTK settings
  programs.dconf.enable = true;
}
