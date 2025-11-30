# modules/home-manager/development/tools/podman.nix
# Podman user configuration
{
  pkgs,
  ...
}:
{
  # Podman is configured system-wide
  # This file handles user-specific settings

  # Podman aliases
  home.shellAliases = {
    docker = "podman";
    docker-compose = "podman-compose";
  };

  # Container tools
  home.packages = with pkgs; [
    lazydocker # TUI for containers
  ];
}
