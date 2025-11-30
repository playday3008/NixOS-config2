# modules/home-manager/programs/browsers/edge.nix
# Microsoft Edge browser (work user)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    microsoft-edge
  ];
}
