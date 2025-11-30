# modules/home-manager/development/languages/go.nix
# Go development environment
{
  config,
  pkgs,
  ...
}:
{
  programs.go = {
    enable = true;
    env = {
      GOPATH = "go";
      GOBIN = "go/bin";
    };
  };

  home.packages = with pkgs; [
    # Language server
    gopls

    # Linters and formatters
    golangci-lint
    gofumpt
    golines

    # Tools
    go-tools # staticcheck, etc.
    delve # Debugger
    gomodifytags
    gotests
    impl
    godef
  ];

  # Environment variables
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
  ];
}
