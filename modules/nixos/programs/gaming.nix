# modules/nixos/programs/gaming.nix
# Gaming configuration
{
  pkgs,
  ...
}:
{
  # ==========================================================================
  # Steam
  # ==========================================================================
  programs.steam = {
    enable = true;

    # Open firewall for Steam Remote Play
    remotePlay.openFirewall = true;

    # Open firewall for Steam Dedicated Server
    dedicatedServer.openFirewall = true;

    # Enable Proton-GE and other compatibility tools
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    # 32-bit library support
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          # Common game dependencies
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils

          # Gamescope dependencies
          gamescope
          mangohud
        ];
    };
  };

  # ==========================================================================
  # GameMode
  # ==========================================================================
  programs.gamemode = {
    enable = true;
    enableRenice = true;

    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 1;
      };

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Stopped'";
      };
    };
  };

  # ==========================================================================
  # Gamescope
  # ==========================================================================
  programs.gamescope = {
    enable = true;
    capSysNice = true;

    args = [
      "--rt"
      "--prefer-vk-device"
    ];
  };

  # ==========================================================================
  # Gaming Packages
  # ==========================================================================
  environment.systemPackages = with pkgs; [
    # Game launchers
    lutris
    heroic

    # Proton/Wine tools
    winetricks
    protontricks

    # Performance monitoring
    mangohud

    # Controller support
    antimicrox # Gamepad to keyboard/mouse mapper
    sc-controller # Steam Controller support

    # Game utilities
    gamemode
  ];

  # ==========================================================================
  # Controller Support
  # ==========================================================================
  # Xbox controller support
  hardware.xone.enable = true;

  # PlayStation controller support
  hardware.steam-hardware.enable = true;

  # Generic gamepad support
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];
}
