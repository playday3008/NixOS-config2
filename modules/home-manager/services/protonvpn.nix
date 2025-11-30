# modules/home-manager/services/protonvpn.nix
# Proton VPN (personal user)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    protonvpn-gui
    # protonvpn-cli  # CLI alternative
  ];

  # ProtonVPN manages its own configuration
  # Login through the GUI after installation
}
