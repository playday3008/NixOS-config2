# modules/nixos/core/boot.nix
# Bootloader, kernel, and initrd configuration
{
  pkgs,
  ...
}:
{
  boot = {
    # Limine bootloader with Secure Boot support
    loader = {
      efi.canTouchEfiVariables = true;

      limine = {
        enable = true;
        efiSupport = true;

        # Secure Boot configuration
        secureBoot.enable = true;

        # Boot menu styling
        style = {
          wallpapers = [
            pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath
          ];
        };

        # Limit generations to prevent boot partition overflow
        maxGenerations = 10;
      };
    };

    # Plymouth boot splash
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    # Silent boot (reduce verbosity)
    consoleLogLevel = 0;
    initrd.verbose = false;

    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Support for NTFS (useful for external drives)
    supportedFilesystems = [ "ntfs" ];
  };
}
