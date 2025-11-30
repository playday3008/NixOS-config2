# modules/home-manager/programs/shells/zsh.nix
# Zsh configuration (default shell)
{
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;

    # Enable autosuggestions and syntax highlighting
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History settings
    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    # Completion settings
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
    '';

    # Shell options
    initContent = ''
      # Better history search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Ctrl+Left/Right for word movement
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word

      # Home/End keys
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line

      # Delete key
      bindkey '^[[3~' delete-char

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Colored completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      # Menu selection
      zstyle ':completion:*' menu select

      # Better directory navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
    '';

    # Aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Listing
      ls = "ls --color=auto";
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";

      # Safety
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      gd = "git diff";

      # Nix shortcuts
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      hms = "home-manager switch --flake .";
      nfu = "nix flake update";
      nfc = "nix flake check";

      # System
      sys = "systemctl";
      sysu = "systemctl --user";
      jour = "journalctl";
    };

    # Plugins
    plugins = [
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      rust.symbol = " ";
      golang.symbol = " ";
      python.symbol = " ";
      nodejs.symbol = " ";
    };
  };

  # Zoxide for better cd
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # fzf for fuzzy finding
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv for per-directory environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
