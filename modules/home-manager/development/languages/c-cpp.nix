# modules/home-manager/development/languages/c-cpp.nix
# C/C++ development environment
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Compilers
    #gcc-unwrapped
    clang

    # Build systems
    cmake
    ninja
    gnumake
    meson

    # Package managers
    conan
    vcpkg

    # Debuggers
    gdb
    lldb

    # Static analysis
    cppcheck
    clang-tools # includes clang-tidy, clangd

    # Documentation
    doxygen

    # Other tools
    pkg-config
    bear # Generate compile_commands.json
    ccache # Compiler cache
  ];

  # Clangd configuration
  xdg.configFile."clangd/config.yaml".text = ''
    CompileFlags:
      Add: [-Wall, -Wextra]
    Diagnostics:
      UnusedIncludes: Strict
    InlayHints:
      Enabled: Yes
      ParameterNames: Yes
      DeducedTypes: Yes
  '';
}
