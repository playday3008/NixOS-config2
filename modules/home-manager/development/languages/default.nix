# modules/home-manager/development/languages/default.nix
# Programming language environments
{
  imports = [
    ./c-cpp.nix
    ./dotnet.nix
    ./rust.nix
    ./go.nix
    ./python.nix
    ./zig.nix
    ./js.nix
  ];
}
