# overlays/default.nix
# Combines all overlays into an attribute set
{ inputs }:
{
  # Add unstable packages as pkgs.unstable
  unstable = import ./unstable.nix { inherit inputs; };

  # Add custom modifications here
  # modifications = import ./modifications.nix { inherit inputs; };
}
