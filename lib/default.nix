# lib/default.nix
# Main library entry point - imports all helper functions
{ inputs }:
let
  # Single source of truth for state versions
  stateVersion = "25.11";

  mkHost = import ./mkHost.nix { inherit inputs stateVersion; };
  mkHome = import ./mkHome.nix { inherit inputs stateVersion; };
in
{
  inherit mkHost mkHome stateVersion;
}
