# modules/nixos/desktop/plasma.nix
# KDE Plasma 6 desktop environment
{
  pkgs,
  ...
}:
{
  # Enable KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # SDDM display manager
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;

      # Theme settings
      settings = { };
    };

    # Default session
    defaultSession = "plasma";
  };

  # XDG portal for Flatpak and screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  # KDE applications and utilities
  environment.systemPackages = with pkgs; [
    # Core KDE apps
    kdePackages.ark # Archive manager
    kdePackages.dolphin # File manager
    kdePackages.dolphin-plugins
    kdePackages.kate # Text editor
    kdePackages.kcalc # Calculator
    kdePackages.kcolorchooser # Color picker
    kdePackages.kdeconnect-kde # Phone integration
    kdePackages.kdenlive # Video editor
    kdePackages.konsole # Terminal
    kdePackages.krfb # VNC server (remote desktop)
    kdePackages.ksystemlog # System log viewer
    kdePackages.okular # Document viewer
    kdePackages.partitionmanager # Disk partitioning
    kdePackages.spectacle # Screenshots

    # KDE system components
    kdePackages.breeze-icons
    kdePackages.kde-cli-tools
    kdePackages.kscreen
    kdePackages.plasma-browser-integration
    kdePackages.plasma-disks
    kdePackages.plasma-nm # Network manager applet
    kdePackages.plasma-pa # PulseAudio/PipeWire applet
    kdePackages.plasma-vault # Encrypted vaults
    kdePackages.sddm-kcm # SDDM settings

    # File indexing
    kdePackages.baloo
    kdePackages.baloo-widgets
  ];

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  # Enable Partition Manager
  programs.partition-manager.enable = true;
}
