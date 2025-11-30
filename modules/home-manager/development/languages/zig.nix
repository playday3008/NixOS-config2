# modules/home-manager/development/languages/zig.nix
# Zig development environment
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Zig compiler
    zig

    # Language server
    zls
  ];
}
