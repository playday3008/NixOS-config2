# lib/default.nix
# Main library entry point - imports all helper functions
{ inputs }:
let
  mkHost = import ./mkHost.nix { inherit inputs; };
  mkHome = import ./mkHome.nix { inherit inputs; };
in
{
  inherit mkHost mkHome;
}
