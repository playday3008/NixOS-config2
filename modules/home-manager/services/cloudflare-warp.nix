# modules/home-manager/services/cloudflare-warp.nix
# Cloudflare WARP / Zero Trust (work user)
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cloudflare-warp
  ];

  # Note: Cloudflare WARP requires system-level service
  # Enable via: services.cloudflare-warp.enable = true
  # in your NixOS configuration if needed

  # The GUI (warp-taskbar) will handle login and configuration
}
