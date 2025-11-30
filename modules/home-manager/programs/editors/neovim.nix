# modules/home-manager/programs/editors/neovim.nix
# Neovim configuration with kickstart.nvim
{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Neovim plugins are managed by kickstart.nvim/lazy.nvim
    # We just need to ensure dependencies are available

    extraPackages = with pkgs; [
      # LSP servers
      nil # Nix
      lua-language-server
      rust-analyzer
      gopls
      pyright
      typescript-language-server
      vscode-langservers-extracted # HTML, CSS, JSON, ESLint
      clang-tools # C/C++
      omnisharp-roslyn # C#
      zls # Zig

      # Formatters
      nixfmt-rfc-style
      stylua
      rustfmt
      gofumpt
      black
      prettierd
      shfmt

      # Linters
      statix
      deadnix
      shellcheck
      eslint

      # Tools
      ripgrep
      fd
      tree-sitter

      # Build tools for treesitter
      gcc
      gnumake
    ];
  };

  # Kickstart.nvim setup
  # The configuration will be cloned manually on first use
  # Run: git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/nvim
  #
  # Or enable declarative management by uncommenting below
  # (requires updating the hash after each update)
  #
  # xdg.configFile."nvim" = {
  #   source = pkgs.fetchFromGitHub {
  #     owner = "nvim-lua";
  #     repo = "kickstart.nvim";
  #     rev = "master";
  #     sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #   };
  #   recursive = true;
  # };
}
