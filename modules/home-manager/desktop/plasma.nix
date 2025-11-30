# modules/home-manager/desktop/plasma.nix
# KDE Plasma user settings
{
  lib,
  ...
}:
{
  # KDE configuration is complex and often best managed via the GUI
  # This file provides some basic declarative settings

  # KDE Global settings
  xdg.configFile."kdeglobals".text = lib.generators.toINI { } {
    General = {
      ColorScheme = "BreezeDark";
      Name = "Breeze Dark";
    };
    Icons = {
      Theme = "breeze-dark";
    };
    KDE = {
      LookAndFeelPackage = "org.kde.breezedark.desktop";
      SingleClick = false;
    };
  };

  # Disable KDE Wallet for SSH
  # (we use ssh-agent instead)
  xdg.configFile."kwalletrc".text = lib.generators.toINI { } {
    Wallet = {
      "First Use" = false;
    };
    "org.freedesktop.secrets" = {
      apiEnabled = false;
    };
  };

  # Spectacle (screenshot) settings
  xdg.configFile."spectaclerc".text = lib.generators.toINI { } {
    General = {
      autoSaveImage = false;
      clipboardGroup = "PostScreenshotCopyImage";
      onLaunchAction = "DoNotTakeScreenshot";
    };
    GuiConfig = {
      captureMode = 0;
    };
  };
}
