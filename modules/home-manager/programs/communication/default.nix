# modules/home-manager/programs/communication/default.nix
# Communication app configurations
{
  imports = [
    ./vesktop.nix
    ./telegram.nix
    ./element.nix
    ./teams.nix
  ];
}
