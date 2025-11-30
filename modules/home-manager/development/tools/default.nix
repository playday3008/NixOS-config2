# modules/home-manager/development/tools/default.nix
# Development tools
{
  imports = [
    ./podman.nix
    ./rider.nix
  ];
}
