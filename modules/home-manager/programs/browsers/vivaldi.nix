# modules/home-manager/programs/browsers/vivaldi.nix
# Vivaldi browser (personal user)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs # For proprietary codecs
  ];
}
