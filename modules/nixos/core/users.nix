# modules/nixos/core/users.nix
# User account definitions
{
  lib,
  pkgs,
  ...
}:
{
  # Don't allow mutable users (declarative only)
  users.mutableUsers = false;

  # Personal user - main account with sudo access
  users.users.personal = {
    isNormalUser = true;
    description = "Personal";
    extraGroups = [
      "wheel" # Sudo access
      "networkmanager" # Network management
      "video" # Video devices
      "audio" # Audio devices
      "input" # Input devices
      "docker" # Container access (if docker enabled)
      "podman" # Podman access
      "libvirtd" # Virtualization
      "kvm" # KVM access
    ];

    # Initial password - CHANGE THIS or use sops-nix
    # Generate with: mkpasswd -m sha-512
    hashedPasswordFile = lib.mkDefault null;
    initialHashedPassword = lib.mkDefault "$6$rounds=500000$placeholder$placeholderplaceholderplaceholderplaceholderplaceholderplacehol";

    shell = pkgs.zsh;
  };

  # Work user - restricted account without sudo
  users.users.work = {
    isNormalUser = true;
    description = "Work";
    extraGroups = [
      "networkmanager" # Network management
      "video" # Video devices
      "audio" # Audio devices
      "input" # Input devices
      "podman" # Podman access
      "libvirtd" # Virtualization
      "kvm" # KVM access
    ];

    # Initial password - CHANGE THIS or use sops-nix
    hashedPasswordFile = lib.mkDefault null;
    initialHashedPassword = lib.mkDefault "$6$rounds=500000$placeholder$placeholderplaceholderplaceholderplaceholderplaceholderplacehol";

    shell = pkgs.zsh;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Create shared directory for both users
  systemd.tmpfiles.rules = [
    "d /shared 0770 root users -"
    "a /shared - - - - default:group:users:rwx"
  ];
}
