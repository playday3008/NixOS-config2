# modules/home-manager/programs/browsers/default.nix
# Browser configurations
# Import specific browsers in user configs as needed
{
  imports = [
    ./firefox.nix
    ./vivaldi.nix
    ./edge.nix
    ./ladybird.nix
  ];
}
