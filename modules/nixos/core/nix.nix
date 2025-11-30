# modules/nixos/core/nix.nix
# Nix daemon and flake configuration
{
  pkgs,
  ...
}:
{
  nix = {
    # Use the latest Nix
    package = pkgs.nix;

    settings = {
      # Enable flakes and new nix command
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Optimize store automatically
      auto-optimise-store = true;

      # Allow sudo users to use nix
      trusted-users = [
        "root"
        "@wheel"
      ];

      # Substituters for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Avoid copying unnecessary files
      warn-dirty = false;
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages is set in lib/mkHost.nix when creating pkgs

  # System state version
  system.stateVersion = "25.05";
}
