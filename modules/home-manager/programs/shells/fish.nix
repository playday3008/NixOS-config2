# modules/home-manager/programs/shells/fish.nix
# Fish shell configuration (alternative shell)
{
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;

    # Shell abbreviations (expand on space)
    shellAbbrs = {
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      gd = "git diff";
    };

    # Shell aliases
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ll = "ls -la";
      la = "ls -a";
      l = "ls -l";
    };

    # Interactive shell init
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Vi mode (optional, uncomment to enable)
      # fish_vi_key_bindings
    '';

    # Plugins
    plugins = [
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
    ];
  };

  # Enable integrations for fish
  programs.starship.enableFishIntegration = true;
  programs.zoxide.enableFishIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.direnv.enableFishIntegration = true;
}
