# modules/home-manager/programs/shells/bash.nix
# Bash configuration (secondary shell)
_:
{
  programs.bash = {
    enable = true;

    # History settings
    historySize = 50000;
    historyFileSize = 50000;
    historyControl = [
      "erasedups"
      "ignorespace"
    ];

    # Shell options
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    # Aliases (shared with zsh)
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ls = "ls --color=auto";
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
    };

    initContent = ''
      # Better prompt if starship is not available
      if ! command -v starship &> /dev/null; then
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      fi
    '';
  };

  # Enable starship for bash too
  programs.starship.enableBashIntegration = true;
  programs.zoxide.enableBashIntegration = true;
  programs.fzf.enableBashIntegration = true;
  programs.direnv.enableBashIntegration = true;
}
