# modules/home-manager/programs/browsers/ladybird.nix
# Ladybird browser (all users)
{
  pkgs,
  ...
}:
{
  # Ladybird is a new independent browser
  # It may not be in nixpkgs stable yet
  home.packages = with pkgs; [
    # ladybird  # Uncomment when available in nixpkgs
  ];

  # Alternative: Use unstable
  # home.packages = [ pkgs.unstable.ladybird ];
}
