# modules/home-manager/programs/communication/telegram.nix
# Telegram Desktop
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    telegram-desktop
  ];
}
