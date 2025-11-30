# modules/home-manager/development/default.nix
# Development environment configurations
{
  imports = [
    ./git.nix
    ./languages
    ./tools
  ];
}
