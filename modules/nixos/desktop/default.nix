# modules/nixos/desktop/default.nix
# Imports all desktop modules
{
  imports = [
    ./plasma.nix
    ./wayland.nix
    ./fonts.nix
    ./audio.nix
    ./printing.nix
  ];
}
