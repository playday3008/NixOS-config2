# NixOS Configuration Justfile
# Run `just` to see available commands

# Default recipe - show help
default:
    @just --list

# ===========================================================================
# System Commands
# ===========================================================================

# Rebuild and switch system configuration
switch host="framework":
    sudo nixos-rebuild switch --flake .#{{host}}

# Test system configuration without switching
test host="framework":
    sudo nixos-rebuild test --flake .#{{host}}

# Build system without activating
build host="framework":
    nixos-rebuild build --flake .#{{host}}

# Rebuild with verbose output
switch-verbose host="framework":
    sudo nixos-rebuild switch --flake .#{{host}} --show-trace

# ===========================================================================
# Home Manager Commands
# ===========================================================================

# Switch home configuration
home user="personal" host="framework":
    home-manager switch --flake .#{{user}}@{{host}}

# Build home configuration
home-build user="personal" host="framework":
    home-manager build --flake .#{{user}}@{{host}}

# ===========================================================================
# Update Commands
# ===========================================================================

# Update all flake inputs
update:
    nix flake update

# Update specific input
update-input input:
    nix flake lock --update-input {{input}}

# Update and rebuild
upgrade host="framework":
    nix flake update
    sudo nixos-rebuild switch --flake .#{{host}}

# ===========================================================================
# Development Commands
# ===========================================================================

# Check flake
check:
    nix flake check

# Format all nix files
fmt:
    nixfmt .

# Lint configuration
lint:
    statix check .

# Find dead code
deadcode:
    deadnix .

# Run all checks
verify: fmt lint check

# ===========================================================================
# Secrets Commands
# ===========================================================================

# Edit secrets
secrets:
    sops secrets/secrets.yaml

# Generate age key
keygen:
    sudo mkdir -p /var/lib/sops-nix
    sudo age-keygen -o /var/lib/sops-nix/key.txt
    @echo "Public key:"
    @sudo age-keygen -y /var/lib/sops-nix/key.txt

# Show age public key
pubkey:
    @sudo age-keygen -y /var/lib/sops-nix/key.txt

# ===========================================================================
# Cleanup Commands
# ===========================================================================

# Garbage collect old generations
gc:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d

# Remove generations older than 7 days
gc-week:
    sudo nix-collect-garbage --delete-older-than 7d

# Optimize nix store
optimize:
    sudo nix-store --optimise

# Full cleanup
clean: gc optimize

# ===========================================================================
# VM Commands
# ===========================================================================

# Build VM for testing
vm-build:
    nixos-rebuild build-vm --flake .#vm

# Run VM
vm-run:
    ./result/bin/run-vm-vm

# ===========================================================================
# Info Commands
# ===========================================================================

# Show system generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Show disk usage
disk:
    duf

# Show nix store size
store-size:
    du -sh /nix/store

# Show flake info
info:
    nix flake metadata

# Show dependency tree
tree pkg:
    nix-tree .#nixosConfigurations.framework.config.system.build.toplevel

# ===========================================================================
# Disko Commands
# ===========================================================================

# Run disko (DESTRUCTIVE - partitions disk)
disko host="framework":
    @echo "WARNING: This will DESTROY all data on the target disk!"
    @echo "Press Ctrl+C to cancel, or Enter to continue..."
    @read
    sudo nix run github:nix-community/disko -- --mode disko --flake .#{{host}}

# ===========================================================================
# Secure Boot Commands
# ===========================================================================

# Create Secure Boot keys
sbctl-create:
    sudo sbctl create-keys

# Enroll Secure Boot keys
sbctl-enroll:
    sudo sbctl enroll-keys -m -f

# Verify Secure Boot status
sbctl-verify:
    sudo sbctl verify

# Full Secure Boot setup
sbctl-setup: sbctl-create sbctl-enroll switch sbctl-verify
