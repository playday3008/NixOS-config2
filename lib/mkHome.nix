# lib/mkHome.nix
# Helper function to create standalone Home Manager configurations
{ inputs }:
{
  username,
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

  # Common home-manager modules for all users
  commonModules = [
    # Sops for user secrets
    inputs.sops-nix.homeManagerModules.sops

    # User-specific configuration
    ../users/${username}

    # Common configuration
    {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };

      # Enable home-manager to manage itself
      programs.home-manager.enable = true;

      # Make inputs available
      _module.args = {
        inherit inputs hostname;
      };
    }
  ];
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = commonModules ++ extraModules;
  extraSpecialArgs = {
    inherit inputs hostname;
  };
}
