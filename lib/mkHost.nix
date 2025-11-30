# lib/mkHost.nix
# Helper function to create NixOS configurations
{ inputs, stateVersion }:
{
  hostname,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = builtins.attrValues (import ../overlays { inherit inputs; });
  };

  # Common modules for all hosts
  commonModules = [
    # Disko for declarative disk management
    inputs.disko.nixosModules.disko

    # Sops for secrets management
    inputs.sops-nix.nixosModules.sops

    # Core system modules
    ../modules/nixos/core

    # Host-specific configuration
    ../hosts/${hostname}

    # Common configuration applied to all hosts
    {
      networking.hostName = hostname;

      # Use externally created pkgs with overlays
      # config.allowUnfree is set when creating pkgs above
      nixpkgs.pkgs = pkgs;

      # Make flake inputs available to modules
      _module.args = {
        inherit inputs stateVersion;
      };
    }
  ];
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  modules = commonModules ++ extraModules;
  specialArgs = {
    inherit inputs stateVersion;
  };
}
