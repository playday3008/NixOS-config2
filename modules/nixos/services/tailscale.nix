# modules/nixos/services/tailscale.nix
# Tailscale VPN configuration
{
  pkgs,
  ...
}:
{
  # Enable Tailscale
  services.tailscale = {
    enable = true;

    # Use userspace networking (better for laptops)
    useRoutingFeatures = "client";

    # Open firewall for Tailscale
    openFirewall = true;
  };

  # Tailscale packages
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  # Persist Tailscale state across reboots
  # (handled automatically by the service)

  # NetworkManager integration
  networking.networkmanager.unmanaged = [ "tailscale0" ];
}
