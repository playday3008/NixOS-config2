# overlays/unstable.nix
# Makes unstable packages available as pkgs.unstable
{ inputs }:
_final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev) system config;
  };
}
