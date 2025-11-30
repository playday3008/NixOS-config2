# modules/home-manager/programs/communication/teams.nix
# Microsoft Teams (work user)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    teams-for-linux
  ];
}
