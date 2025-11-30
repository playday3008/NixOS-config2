# modules/home-manager/development/languages/python.nix
# Python development environment
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Python interpreter
    python3

    # Package management
    python3Packages.pip
    python3Packages.virtualenv
    uv # Fast package installer
    pipx # Install Python apps in isolated environments

    # Language server
    pyright
    python3Packages.python-lsp-server

    # Formatters
    black
    python3Packages.isort

    # Linters
    ruff
    python3Packages.flake8
    python3Packages.mypy

    # Tools
    python3Packages.ipython
    python3Packages.pytest
  ];

  # Pip configuration
  xdg.configFile."pip/pip.conf".text = ''
    [global]
    break-system-packages = false
    require-virtualenv = true

    [install]
    user = false
  '';

  # Environment variables
  home.sessionVariables = {
    PYTHONDONTWRITEBYTECODE = "1";
    PIP_REQUIRE_VIRTUALENV = "true";
  };
}
