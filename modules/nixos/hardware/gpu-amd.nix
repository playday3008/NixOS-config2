# modules/nixos/hardware/gpu-amd.nix
# AMD GPU configuration
{
  pkgs,
  ...
}:
{
  # AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Hardware acceleration
  # RADV Vulkan driver is enabled by default
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      # VA-API for video acceleration
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Environment variables for AMD
  environment.variables = {
    # Use RADV by default (better for gaming)
    AMD_VULKAN_ICD = "RADV";
  };

  # ROCm for compute (ML/AI workloads)
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # ROCm packages
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi # GPU monitoring
    rocmPackages.clr # HIP runtime
  ];
}
