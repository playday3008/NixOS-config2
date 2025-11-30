# modules/nixos/desktop/fonts.nix
# System fonts configuration
{
  pkgs,
  ...
}:
{
  # System fonts
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      # Nerd Fonts (patched fonts with icons)
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono

      # Standard fonts
      liberation_ttf
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      # Microsoft fonts (for compatibility)
      corefonts
      vista-fonts

      # Additional programming fonts
      fira-code
      jetbrains-mono
      source-code-pro
      cascadia-code

      # UI fonts
      inter
      roboto
      open-sans
    ];

    # Font configuration
    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [
          "Noto Serif"
          "DejaVu Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "DejaVu Sans"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
          "DejaVu Sans Mono"
        ];
        emoji = [ "Noto Color Emoji" ];
      };

      # Improve font rendering
      hinting = {
        enable = true;
        style = "slight";
      };

      antialias = true;

      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };
}
