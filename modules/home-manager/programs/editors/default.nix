# modules/home-manager/programs/editors/default.nix
# Editor configurations
{
  imports = [
    ./neovim.nix
    ./vscode.nix
  ];
}
