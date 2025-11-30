# modules/home-manager/programs/shells/default.nix
# Shell configurations
{
  imports = [
    ./zsh.nix
    ./bash.nix
    ./fish.nix
  ];
}
