# modules/home-manager/development/languages/js.nix
# JavaScript/TypeScript development environment
{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Runtimes
    deno
    bun
    nodejs_22

    # Package managers
    nodePackages.pnpm

    # Language servers
    typescript-language-server
    vscode-langservers-extracted # HTML, CSS, JSON, ESLint

    # Formatters
    prettierd
    nodePackages.prettier

    # Linters
    eslint

    # Tools
    nodePackages.typescript
  ];

  # Deno configuration
  home.sessionVariables = {
    DENO_INSTALL = "${config.home.homeDirectory}/.deno";
  };

  # npm configuration
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    init-author-name=
    init-author-email=
    init-license=MIT
  '';

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.deno/bin"
  ];
}
