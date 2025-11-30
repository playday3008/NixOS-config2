# users/personal/default.nix
# Personal user home-manager configuration
{
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Shell configuration
    ../../modules/home-manager/programs/shells

    # Terminal
    ../../modules/home-manager/programs/terminals

    # Editors
    ../../modules/home-manager/programs/editors

    # Desktop customization
    ../../modules/home-manager/desktop

    # Development environment
    ../../modules/home-manager/development

    # Gaming (personal only)
    ../../modules/home-manager/programs/gaming
  ];

  # ===========================================================================
  # User Information
  # ===========================================================================
  programs.git = {
    userName = "Your Name"; # TODO: Change this
    userEmail = "personal@example.com"; # TODO: Change this
  };

  # ===========================================================================
  # Browsers (Personal)
  # ===========================================================================
  # Firefox (configured in module)
  programs.firefox.enable = true;

  # Vivaldi
  home.packages =
    with pkgs;
    [
      vivaldi
      vivaldi-ffmpeg-codecs
    ]
    ++
      # Ladybird (if available)
      [ pkgs.ladybird ]

      # ===========================================================================
      # Communication (Personal)
      # ===========================================================================
      [
        vesktop # Discord
        telegram-desktop
        element-desktop # Matrix
      ]
    ++

      # ===========================================================================
      # VPN (Personal)
      # ===========================================================================
      [
        protonvpn-gui
      ]
    ++

      # ===========================================================================
      # Productivity
      # ===========================================================================
      [
        libreoffice-qt6
        obsidian # Note taking
        spotify
      ]
    ++

      # ===========================================================================
      # Media
      # ===========================================================================
      [
        vlc
        mpv
        gimp
        inkscape
      ]
    ++

      # ===========================================================================
      # Utilities
      # ===========================================================================
      [
        btop # System monitor
        fastfetch # System info
        p7zip
        unrar
        unzip
        zip
        wget
        curl
        tree
        jq
        yq
        bat # Better cat
        eza # Better ls
        fd # Better find
        ripgrep
        duf # Disk usage
        ncdu # Disk usage TUI
        tldr # Simplified man pages
      ];

  # ===========================================================================
  # XDG Configuration
  # ===========================================================================
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "org.kde.okular.desktop";
        "image/*" = "org.kde.gwenview.desktop";
        "video/*" = "vlc.desktop";
        "audio/*" = "vlc.desktop";
      };
    };
  };

  # ===========================================================================
  # SSH Configuration
  # ===========================================================================
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;

  # ===========================================================================
  # Shell Aliases (Personal-specific)
  # ===========================================================================
  home.shellAliases = {
    # Quick rebuild commands
    rebuild = "sudo nixos-rebuild switch --flake ~/Documents/GitHub/NixOS-config#framework";
    rebuild-home = "home-manager switch --flake ~/Documents/GitHub/NixOS-config#personal@framework";

    # Navigation to common dirs
    docs = "cd ~/Documents";
    dl = "cd ~/Downloads";
    proj = "cd ~/Projects";
    conf = "cd ~/Documents/GitHub/NixOS-config";
  };
}
