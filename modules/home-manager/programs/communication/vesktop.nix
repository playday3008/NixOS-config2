# modules/home-manager/programs/communication/vesktop.nix
# Vesktop (Discord client with Vencord)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vesktop
  ];

  # Vesktop config (optional customization)
  xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
    # Enable system tray
    tray = true;
    minimizeToTray = true;

    # Hardware acceleration
    hardwareAcceleration = true;

    # Appearance
    staticTitle = false;
    enableMenu = true;
  };
}
