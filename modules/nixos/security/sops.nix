# modules/nixos/security/sops.nix
# sops-nix secrets management configuration
{
  config,
  pkgs,
  ...
}:
{
  # sops-nix configuration
  sops = {
    # Default sops file location
    defaultSopsFile = ../../../secrets/secrets.yaml;

    # Age key file location (created during setup)
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # Generate key file if it doesn't exist
    age.generateKey = true;

    # Secrets definitions
    secrets."personal/password" = {
      neededForUsers = true;
    };
    secrets."work/password" = {
      neededForUsers = true;
    };
    secrets."tailscale/authkey" = { };
  };

  # Ensure sops and age are available
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
