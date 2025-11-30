# hosts/framework/disko.nix
# Disko configuration for Framework Laptop 16
# LUKS encrypted BTRFS with subvolumes
{
  ...
}:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Change this to your actual disk device
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };

            # LUKS encrypted root partition
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";

                # LUKS settings
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };

                # Password will be prompted during installation
                # For automated installs, you can use keyFile
                passwordFile = "/tmp/luks-password";

                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];

                  subvolumes = {
                    # Root subvolume
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };

                    # Home subvolume
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };

                    # Nix store subvolume
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };

                    # Shared data subvolume
                    "@shared" = {
                      mountpoint = "/shared";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };

                    # Snapshots subvolume
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                        "ssd"
                        "discard=async"
                      ];
                    };

                    # Swap subvolume (for hibernation support)
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "32G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # Enable swap
  swapDevices = [ ];

  # Required for LUKS
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  # Filesystem options
  fileSystems = {
    "/".neededForBoot = true;
    "/home".neededForBoot = true;
    "/nix".neededForBoot = true;
  };
}
