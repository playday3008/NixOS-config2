# modules/home-manager/development/git.nix
# Git configuration
{
  lib,
  ...
}:
{
  programs.git = {
    enable = true;

    # Git settings (new unified format)
    settings = {
      # User info - override in user config
      user.name = lib.mkDefault "Your Name";
      user.email = lib.mkDefault "your.email@example.com";

      # Default branch
      init.defaultBranch = "main";

      # Better diffs
      diff.algorithm = "histogram";
      diff.colorMoved = "default";

      # Merge settings
      merge.conflictStyle = "zdiff3";

      # Push settings
      push.autoSetupRemote = true;
      push.default = "current";

      # Pull settings
      pull.rebase = true;

      # Rebase settings
      rebase.autoStash = true;
      rebase.autoSquash = true;

      # Credential helper
      credential.helper = "cache --timeout=3600";

      # Core settings
      core.editor = "nvim";
      core.autocrlf = "input";
      core.whitespace = "trailing-space,space-before-tab";

      # Color
      color.ui = "auto";

      # URL rewrites
      url."git@github.com:".insteadOf = "gh:";
      url."git@gitlab.com:".insteadOf = "gl:";

      # Git aliases
      alias = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        ci = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --oneline --graph --decorate";
        lga = "log --oneline --graph --decorate --all";
        d = "diff";
        ds = "diff --staged";
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";
        f = "fetch --all --prune";
        undo = "reset --soft HEAD~1";
        wip = "commit -am 'WIP'";
      };
    };

    # Signing (optional - configure per user)
    # signing = {
    #   signByDefault = true;
    #   key = "YOUR_GPG_KEY_ID";
    # };
  };

  # Delta for better diffs (moved to programs.delta)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "Dracula";
    };
  };

  # Lazygit TUI
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
          activeBorderColor = [
            "green"
            "bold"
          ];
          inactiveBorderColor = [ "white" ];
          selectedLineBgColor = [ "blue" ];
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
