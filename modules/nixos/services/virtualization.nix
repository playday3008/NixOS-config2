# modules/nixos/services/virtualization.nix
# Virtualization and container configuration
{
  pkgs,
  ...
}:
{
  # ==========================================================================
  # Podman (Container Runtime)
  # ==========================================================================
  virtualisation.podman = {
    enable = true;

    # Docker compatibility
    dockerCompat = true;
    dockerSocket.enable = true;

    # Default network configuration
    defaultNetwork.settings.dns_enabled = true;

    # Enable rootless containers
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # ==========================================================================
  # NixOS Containers
  # ==========================================================================
  # Native NixOS containers (declarative)
  # Add container definitions here if needed
  # containers.example = {
  #   config = { ... };
  # };

  # ==========================================================================
  # libvirt / QEMU (Virtual Machines)
  # ==========================================================================
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;

      # TPM support for VMs
      swtpm.enable = true;
    };
  };

  # Virt-manager GUI
  programs.virt-manager.enable = true;

  # Spice support for better VM display
  virtualisation.spiceUSBRedirection.enable = true;

  # ==========================================================================
  # Packages
  # ==========================================================================
  environment.systemPackages = with pkgs; [
    # Container tools
    podman-compose
    podman-tui
    dive # Container image explorer
    skopeo # Container image utility
    buildah # Container image builder

    # VM tools
    virt-viewer
    spice-gtk
  ];
}
