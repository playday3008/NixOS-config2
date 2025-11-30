# modules/home-manager/programs/communication/element.nix
# Element (Matrix client)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    element-desktop
  ];
}
