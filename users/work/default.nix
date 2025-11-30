# users/work/default.nix
# Work user home-manager configuration
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
  ];

  # ===========================================================================
  # User Information
  # ===========================================================================
  programs.git = {
    userName = "Your Work Name"; # TODO: Change this
    userEmail = "work@company.com"; # TODO: Change this
  };

  # ===========================================================================
  # Browsers (Work)
  # ===========================================================================
  # Firefox (configured in module)
  programs.firefox.enable = true;

  # Microsoft Edge + Ladybird
  home.packages =
    with pkgs;
    [
      microsoft-edge
    ]
    ++
      # Ladybird (if available)
      # [ pkgs.ladybird ]

      # ===========================================================================
      # Communication (Work)
      # ===========================================================================
      [
        teams-for-linux
      ]
    ++

      # ===========================================================================
      # VPN (Work)
      # ===========================================================================
      [
        cloudflare-warp
      ]
    ++

      # ===========================================================================
      # Development Tools (Work-specific)
      # ===========================================================================
      [
        jetbrains.rider # .NET IDE
      ]
    ++

      # ===========================================================================
      # Productivity
      # ===========================================================================
      [
        libreoffice-qt6
      ]
    ++

      # ===========================================================================
      # Utilities
      # ===========================================================================
      [
        btop
        fastfetch
        p7zip
        unzip
        zip
        wget
        curl
        tree
        jq
        yq
        bat
        eza
        fd
        ripgrep
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
      # Add work-specific SSH hosts here
      # "work-server" = {
      #   hostname = "server.company.com";
      #   user = "username";
      #   identityFile = "~/.ssh/id_ed25519_work";
      # };
    };
  };

  services.ssh-agent.enable = true;

  # ===========================================================================
  # Shell Aliases (Work-specific)
  # ===========================================================================
  home.shellAliases = {
    # Quick rebuild commands
    rebuild = "sudo nixos-rebuild switch --flake ~/Documents/GitHub/NixOS-config#framework";
    rebuild-home = "home-manager switch --flake ~/Documents/GitHub/NixOS-config#work@framework";

    # Navigation
    docs = "cd ~/Documents";
    dl = "cd ~/Downloads";
    proj = "cd ~/Projects";
  };

  # ===========================================================================
  # Work-specific Environment
  # ===========================================================================
  home.sessionVariables = {
    # Add work-specific environment variables here
    # WORK_VAR = "value";
  };
}
