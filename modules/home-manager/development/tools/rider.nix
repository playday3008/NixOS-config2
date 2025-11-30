# modules/home-manager/development/tools/rider.nix
# JetBrains Rider IDE (work user)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    jetbrains.rider
  ];

  # JetBrains settings sync is handled by the IDE itself
  # You can add custom settings here if needed
}
