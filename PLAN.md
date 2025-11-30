# NixOS Configuration Implementation Plan

## Overview

A comprehensive Modular Monorepo NixOS configuration for a Framework Laptop 16 with two user accounts (personal/work), KDE Plasma on Wayland, full disk encryption, Secure Boot, and development tools.

---

## Requirements Summary

### Hardware
- **Host**: Framework Laptop 16 (hostname: `framework`)
- **CPU**: AMD (via nixos-hardware)
- **GPU**: AMD RX 7700S
- **RAM**: 96GB
- **VM**: For testing configurations

### Users
| User | Sudo | VPN | Browsers | Communication | Extras |
|------|------|-----|----------|---------------|--------|
| `personal` | Yes | Proton VPN | Firefox, Vivaldi, Ladybird | Vesktop, Telegram, Matrix | Gaming (Steam, Lutris, Heroic) |
| `work` | No | Cloudflare WARP | Firefox, Edge, Ladybird | Teams | Rider IDE |

### Shared Between Users
- `/shared` directory
- LibreOffice, Flatpak apps
- Development tools (Neovim, VS Code)
- Printing/scanning, Bluetooth

### System
- **DE**: KDE Plasma 6 (Wayland)
- **Theme**: Breeze Dark
- **Bootloader**: Limine + Secure Boot (sbctl)
- **Encryption**: Full disk LUKS via disko
- **Boot splash**: Plymouth
- **Packages**: Stable by default, unstable available as `pkgs.unstable`

### Development
- **Languages**: C/C++, .NET, Rust, Go, Python, Zig, Deno/Bun
- **Editors**: Neovim (kickstart), VS Code, Rider (work)
- **Containers**: Podman, NixOS containers
- **Virtualization**: libvirt/QEMU

### Remote Access
- Tailscale
- KDE Connect
- Krfb (KDE VNC)

### Secrets
- sops-nix with age encryption
- New age key (not derived from SSH)

---

## Directory Structure

```
nixos-config/
├── flake.nix                    # Main flake entry point
├── flake.lock                   # Locked dependencies
│
├── lib/                         # Helper functions
│   ├── default.nix              # Main lib entry (imports all)
│   ├── mkHost.nix               # NixOS host builder
│   └── mkHome.nix               # Home-manager config builder
│
├── hosts/                       # Machine-specific configurations
│   ├── framework/               # Main laptop
│   │   ├── default.nix          # Host entry point
│   │   ├── hardware.nix         # Hardware-specific config
│   │   └── disko.nix            # Disk partitioning
│   └── vm/                      # Testing VM
│       ├── default.nix
│       ├── hardware.nix
│       └── disko.nix
│
├── modules/                     # Reusable NixOS modules
│   ├── nixos/                   # System-level modules
│   │   ├── core/                # Base system configuration
│   │   │   ├── default.nix      # Imports all core modules
│   │   │   ├── boot.nix         # Bootloader, initrd, kernel
│   │   │   ├── nix.nix          # Nix settings, gc, flakes
│   │   │   ├── locale.nix       # Timezone, locale, i18n
│   │   │   ├── networking.nix   # NetworkManager, firewall
│   │   │   ├── security.nix     # Polkit, sudo, PAM
│   │   │   └── users.nix        # User account definitions
│   │   │
│   │   ├── desktop/             # Desktop environment
│   │   │   ├── default.nix
│   │   │   ├── plasma.nix       # KDE Plasma + SDDM
│   │   │   ├── wayland.nix      # Wayland-specific settings
│   │   │   ├── fonts.nix        # System fonts
│   │   │   ├── audio.nix        # PipeWire + audio
│   │   │   └── printing.nix     # CUPS + scanning
│   │   │
│   │   ├── hardware/            # Hardware support
│   │   │   ├── default.nix
│   │   │   ├── bluetooth.nix    # Bluetooth config
│   │   │   ├── gpu-amd.nix      # AMD GPU drivers
│   │   │   └── power.nix        # Power management, TLP/PPD
│   │   │
│   │   ├── programs/            # System-wide programs
│   │   │   ├── default.nix
│   │   │   ├── flatpak.nix      # Flatpak setup
│   │   │   └── gaming.nix       # Steam, Gamemode, Gamescope
│   │   │
│   │   ├── services/            # System services
│   │   │   ├── default.nix
│   │   │   ├── tailscale.nix    # Tailscale VPN
│   │   │   ├── kdeconnect.nix   # KDE Connect
│   │   │   └── virtualization.nix # libvirt, Podman, containers
│   │   │
│   │   └── security/            # Security modules
│   │       ├── default.nix
│   │       └── sops.nix         # sops-nix setup
│   │
│   └── home-manager/            # Home-manager modules
│       ├── programs/            # User programs
│       │   ├── default.nix
│       │   ├── shells/          # Shell configurations
│       │   │   ├── default.nix
│       │   │   ├── zsh.nix      # Zsh config
│       │   │   ├── bash.nix     # Bash config
│       │   │   └── fish.nix     # Fish config
│       │   ├── terminals/
│       │   │   ├── default.nix
│       │   │   └── konsole.nix  # Konsole config
│       │   ├── editors/
│       │   │   ├── default.nix
│       │   │   ├── neovim.nix   # Kickstart.nvim setup
│       │   │   └── vscode.nix   # VS Code + extensions
│       │   ├── browsers/
│       │   │   ├── default.nix
│       │   │   ├── firefox.nix
│       │   │   ├── vivaldi.nix
│       │   │   ├── edge.nix
│       │   │   └── ladybird.nix
│       │   ├── communication/
│       │   │   ├── default.nix
│       │   │   ├── vesktop.nix
│       │   │   ├── telegram.nix
│       │   │   ├── element.nix  # Matrix client
│       │   │   └── teams.nix
│       │   └── gaming/
│       │       ├── default.nix
│       │       ├── steam.nix
│       │       ├── lutris.nix
│       │       ├── heroic.nix
│       │       └── mangohud.nix # MangoHud config
│       │
│       ├── desktop/             # Desktop customization
│       │   ├── default.nix
│       │   ├── plasma.nix       # KDE Plasma user settings
│       │   └── gtk.nix          # GTK theming (for non-Qt apps)
│       │
│       ├── development/         # Development tools
│       │   ├── default.nix
│       │   ├── git.nix          # Git configuration
│       │   ├── languages/       # Language-specific setups
│       │   │   ├── default.nix
│       │   │   ├── c-cpp.nix    # C/C++ toolchain
│       │   │   ├── dotnet.nix   # .NET SDK
│       │   │   ├── rust.nix     # Rust toolchain
│       │   │   ├── go.nix       # Go toolchain
│       │   │   ├── python.nix   # Python setup
│       │   │   ├── zig.nix      # Zig toolchain
│       │   │   └── js.nix       # Deno, Bun, Node
│       │   └── tools/           # Dev utilities
│       │       ├── default.nix
│       │       ├── podman.nix   # Podman user config
│       │       └── rider.nix    # JetBrains Rider
│       │
│       └── services/            # User services
│           ├── default.nix
│           ├── protonvpn.nix    # Proton VPN
│           └── cloudflare-warp.nix # CF Zero Trust
│
├── users/                       # User-specific configurations
│   ├── personal/                # Personal user
│   │   ├── default.nix          # Main home-manager config
│   │   └── secrets.nix          # User-specific secrets
│   └── work/                    # Work user
│       ├── default.nix
│       └── secrets.nix
│
├── overlays/                    # Package overlays
│   ├── default.nix              # Overlay entry point
│   └── unstable.nix             # Unstable packages overlay
│
├── packages/                    # Custom packages (future use)
│   └── default.nix
│
├── secrets/                     # Encrypted secrets (sops)
│   ├── secrets.yaml             # Main secrets file
│   └── .sops.yaml               # sops configuration
│
├── templates/                   # Flake templates (future use)
│   └── default/
│       └── flake.nix
│
└── docs/                        # Documentation
    ├── INSTALL.md               # Installation guide
    └── SECRETS.md               # Secrets management guide
```

---

## Implementation Phases

### Phase 1: Foundation
Core infrastructure that everything else depends on.

1. **Restructure flake.nix**
   - Update inputs (add missing ones if needed)
   - Set up stable/unstable package sets
   - Configure overlay system
   - Update lib imports

2. **Create lib/ helpers**
   - `mkHost.nix` - Build NixOS configurations
   - `mkHome.nix` - Build home-manager configurations
   - Helper functions for module options

3. **Set up overlays/**
   - `unstable.nix` - Access unstable packages as `pkgs.unstable`
   - `default.nix` - Combine all overlays

4. **Create modules/nixos/core/**
   - `nix.nix` - Flakes, gc, substituters
   - `locale.nix` - Timezone (auto-detect?), locale
   - `networking.nix` - NetworkManager, hostname, firewall
   - `security.nix` - Polkit, sudo rules, PAM
   - `users.nix` - User definitions (personal, work)
   - `boot.nix` - Limine, Secure Boot, Plymouth, initrd

### Phase 2: Hardware & Desktop
Machine-specific and desktop environment setup.

5. **Create hosts/framework/**
   - `hardware.nix` - nixos-hardware import, ambient light sensor
   - `disko.nix` - LUKS + partitioning scheme
   - `default.nix` - Import modules, host-specific overrides

6. **Create hosts/vm/**
   - Simplified config for testing
   - Minimal disko setup

7. **Create modules/nixos/hardware/**
   - `gpu-amd.nix` - AMDGPU, Vulkan, VA-API
   - `bluetooth.nix` - Bluetooth stack
   - `power.nix` - PPD/TLP integration

8. **Create modules/nixos/desktop/**
   - `plasma.nix` - KDE Plasma 6, SDDM
   - `wayland.nix` - Wayland session, XWayland
   - `fonts.nix` - Nerd fonts, system fonts
   - `audio.nix` - PipeWire, WirePlumber
   - `printing.nix` - CUPS, SANE

### Phase 3: System Services
Services that run system-wide.

9. **Create modules/nixos/services/**
   - `tailscale.nix` - Tailscale daemon
   - `kdeconnect.nix` - KDE Connect + firewall rules
   - `virtualization.nix` - libvirt, QEMU, Podman

10. **Create modules/nixos/programs/**
    - `flatpak.nix` - Flatpak + Flathub
    - `gaming.nix` - Steam, Gamemode, Gamescope

11. **Create modules/nixos/security/**
    - `sops.nix` - sops-nix configuration

### Phase 4: Secrets Management
Set up encrypted secrets.

12. **Initialize sops-nix**
    - Generate age key
    - Create `.sops.yaml` configuration
    - Create initial `secrets.yaml`
    - Document secrets workflow

### Phase 5: Home Manager Foundation
Base home-manager setup.

13. **Update flake.nix for standalone home-manager**
    - Add `homeConfigurations` output
    - Create activation scripts

14. **Create lib/mkHome.nix**
    - Home-manager configuration builder
    - Per-user module composition

15. **Create modules/home-manager/programs/shells/**
    - `zsh.nix` - Oh-my-zsh or manual, plugins, aliases
    - `bash.nix` - Basic bash config
    - `fish.nix` - Fish shell config

16. **Create modules/home-manager/programs/terminals/**
    - `konsole.nix` - Konsole profiles, themes

### Phase 6: Development Environment
Development tools and languages.

17. **Create modules/home-manager/programs/editors/**
    - `neovim.nix` - Kickstart.nvim integration
    - `vscode.nix` - VS Code + extensions

18. **Create modules/home-manager/development/languages/**
    - `c-cpp.nix` - GCC, Clang, CMake, ninja
    - `dotnet.nix` - .NET SDK
    - `rust.nix` - Rustup or nixpkgs rust
    - `go.nix` - Go toolchain
    - `python.nix` - Python + venv
    - `zig.nix` - Zig compiler
    - `js.nix` - Deno, Bun, Node.js

19. **Create modules/home-manager/development/tools/**
    - `git.nix` - Git config, delta, lazygit
    - `podman.nix` - User Podman config
    - `rider.nix` - JetBrains Rider (work only)

### Phase 7: User Applications
User-facing applications.

20. **Create modules/home-manager/programs/browsers/**
    - `firefox.nix` - Firefox + policies
    - `vivaldi.nix` - Vivaldi browser
    - `edge.nix` - Microsoft Edge
    - `ladybird.nix` - Ladybird browser

21. **Create modules/home-manager/programs/communication/**
    - `vesktop.nix` - Vesktop (Discord)
    - `telegram.nix` - Telegram Desktop
    - `element.nix` - Element (Matrix)
    - `teams.nix` - Microsoft Teams

22. **Create modules/home-manager/programs/gaming/**
    - `steam.nix` - Steam user config
    - `lutris.nix` - Lutris setup
    - `heroic.nix` - Heroic launcher
    - `mangohud.nix` - MangoHud configuration

### Phase 8: User-Specific Configs
Per-user configurations.

23. **Create users/personal/**
    - `default.nix` - Import personal modules
    - Enable: gaming, Proton VPN, Vesktop, Telegram, Matrix
    - Browsers: Firefox, Vivaldi, Ladybird

24. **Create users/work/**
    - `default.nix` - Import work modules
    - Enable: Rider, Teams, Cloudflare WARP
    - Browsers: Firefox, Edge, Ladybird

25. **Create modules/home-manager/services/**
    - `protonvpn.nix` - Proton VPN client
    - `cloudflare-warp.nix` - Cloudflare Zero Trust

### Phase 9: Desktop Customization
KDE and theming.

26. **Create modules/home-manager/desktop/**
    - `plasma.nix` - KDE user settings, Breeze Dark
    - `gtk.nix` - GTK theme to match KDE

### Phase 10: Shared Resources
Cross-user resources.

27. **Configure /shared directory**
    - Create systemd-tmpfiles rule
    - Set permissions for both users
    - Add to relevant paths

### Phase 11: Documentation & Utilities

28. **Create docs/**
    - `INSTALL.md` - Fresh installation guide
    - `SECRETS.md` - How to manage secrets

29. **Update devShell**
    - Add deployment helpers
    - Add secret management commands

30. **Create justfile or Makefile**
    - Common operations shortcuts
    - `rebuild`, `update`, `gc`, etc.

---

## Key Configuration Details

### Disko Partition Scheme (framework)
```
/dev/nvme0n1
├── ESP (512MB) - /boot - FAT32
└── LUKS encrypted
    └── BTRFS
        ├── @ -> /
        ├── @home -> /home
        ├── @nix -> /nix
        ├── @shared -> /shared
        └── @snapshots -> /.snapshots
```

### Package Channel Strategy
```nix
# In overlay
final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (prev) system;
    config.allowUnfree = true;
  };
}

# Usage in modules
{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.firefox           # From stable
    pkgs.unstable.neovim   # From unstable
  ];
}
```

### Home Manager Standalone Commands
```bash
# Rebuild personal user
home-manager switch --flake .#personal@framework

# Rebuild work user
home-manager switch --flake .#work@framework

# System rebuild (separate)
sudo nixos-rebuild switch --flake .#framework
```

### Secrets Structure
```yaml
# secrets/secrets.yaml
personal:
  protonvpn_credentials: ENC[...]
work:
  cloudflare_warp_token: ENC[...]
shared:
  tailscale_auth_key: ENC[...]
```

---

## Questions Resolved

| Question | Answer |
|----------|--------|
| Bootloader | Limine + Secure Boot (sbctl) |
| Home Manager | Standalone |
| Secrets encryption | age (new key) |
| Default packages | Stable (unstable via `pkgs.unstable`) |
| Terminal | Konsole |
| Neovim | Kickstart.nvim via home-manager |
| Shared folder | `/shared` with BTRFS subvolume |

---

## Next Steps

After plan approval:
1. Start with Phase 1 (Foundation)
2. Each phase will be implemented incrementally
3. Test in VM before applying to framework host
4. Document as we go

---

## Notes

- NixOS 25.05 is current stable, 25.11 releasing soon
- Will use `nixpkgs/25.11-beta` as default, `nixpkgs-unstable` available as unstable
- Framework Laptop 16 has nixos-hardware support
- Ambient light sensor needs manual configuration (not in nixos-hardware)
