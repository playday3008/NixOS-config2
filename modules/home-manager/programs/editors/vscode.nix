# modules/home-manager/programs/editors/vscode.nix
# VS Code configuration
{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # Official Microsoft build

    # Extensions
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide

      # Languages
      rust-lang.rust-analyzer
      golang.go
      ms-python.python
      ms-python.vscode-pylance
      ms-dotnettools.csharp

      # Web development
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode

      # Git
      eamodio.gitlens
      mhutchie.git-graph

      # Editor enhancements
      vscodevim.vim
      usernamehw.errorlens
      streetsidesoftware.code-spell-checker

      # Theme
      catppuccin.catppuccin-vsc
      pkief.material-icon-theme

      # Utilities
      editorconfig.editorconfig
      christian-kohler.path-intellisense
      formulahendry.auto-rename-tag
    ];

    # VS Code settings
    profiles.default.userSettings = {
      # Editor
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Fira Code', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.lineNumbers" = "relative";
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.wordWrap" = "on";
      "editor.cursorBlinking" = "smooth";
      "editor.smoothScrolling" = true;
      "editor.bracketPairColorization.enabled" = true;

      # Terminal
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "terminal.integrated.fontSize" = 13;

      # Files
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      # Explorer
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;

      # Workbench
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";

      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };

      # Git
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;

      # Telemetry
      "telemetry.telemetryLevel" = "off";
      "redhat.telemetry.enabled" = false;
    };
  };
}
