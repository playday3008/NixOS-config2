# hosts/vm/disko.nix
# Disko configuration for VM (simplified, no encryption)
_:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
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
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "@shared" = {
                      mountpoint = "/shared";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    # Swap subvolume (smaller for VM)
                    "@swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "2G";
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
}
