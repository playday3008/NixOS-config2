# modules/home-manager/desktop/default.nix
# Desktop customization
{
  imports = [
    ./plasma.nix
    ./gtk.nix
  ];
}
