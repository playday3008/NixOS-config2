# modules/home-manager/development/languages/rust.nix
# Rust development environment
{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Rust toolchain (stable)
    rustc
    cargo
    rustfmt
    clippy

    # Language server
    rust-analyzer

    # Additional tools
    cargo-edit # cargo add/rm/upgrade
    cargo-watch # Watch and rebuild
    cargo-expand # Macro expansion
    cargo-audit # Security audit
    cargo-outdated # Check outdated deps
    cargo-bloat # Binary size analysis
    cargo-flamegraph # Performance profiling

    # LLVM tools for Rust
    lldb
  ];

  # Cargo configuration
  home.file.".cargo/config.toml".text = ''
    [build]
    # Use all cores
    jobs = -1

    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=lld"]

    [net]
    git-fetch-with-cli = true
  '';

  # Environment variables
  home.sessionVariables = {
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
    RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];
}
