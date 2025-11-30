# modules/home-manager/programs/default.nix
# Entry point for all home-manager program modules
# Individual modules are imported by user configurations as needed
{
  imports = [
    ./shells
    ./terminals
    ./editors
    ./browsers
    ./communication
    ./gaming
  ];
}
