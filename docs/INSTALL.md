# Installation Guide

This guide walks through installing NixOS using this configuration.

## Prerequisites

- NixOS installation ISO (minimal or graphical)
- USB drive for installation media
- Internet connection
- Backup of any existing data

## Step 1: Boot from NixOS ISO

1. Download NixOS ISO from https://nixos.org/download
2. Flash to USB: `dd if=nixos.iso of=/dev/sdX bs=4M status=progress`
3. Boot from USB

## Step 2: Connect to Network

```bash
# For WiFi
nmcli device wifi connect "SSID" password "password"

# Verify connection
ping -c 3 nixos.org
```

## Step 3: Enable Flakes

```bash
nix-shell -p git nixFlakes
```

## Step 4: Clone Configuration

```bash
git clone https://github.com/YOUR_USERNAME/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config
```

## Step 5: Partition Disks with Disko

```bash
# Create LUKS password file
echo "your-secure-password" > /tmp/luks-password

# Run disko (for framework host)
sudo nix run github:nix-community/disko -- \
  --mode disko \
  --flake .#framework

# For VM
# sudo nix run github:nix-community/disko -- --mode disko --flake .#vm
```

## Step 6: Install NixOS

```bash
# Install system
sudo nixos-install --flake .#framework --no-root-passwd

# The --no-root-passwd flag is used because we set user passwords declaratively
```

## Step 7: Post-Installation Setup

### Reboot

```bash
sudo reboot
```

### Login and Setup Secure Boot

If using Secure Boot with Limine:

```bash
# Generate Secure Boot keys
sudo sbctl create-keys

# Enroll keys (reset Secure Boot to Setup Mode first in BIOS)
sudo sbctl enroll-keys -m -f

# Rebuild to sign bootloader
sudo nixos-rebuild switch --flake ~/Documents/GitHub/NixOS-config#framework

# Verify
sudo sbctl verify

# Enable Secure Boot in BIOS
```

### Setup Secrets

```bash
# Generate age key
age-keygen -o /var/lib/sops-nix/key.txt

# Get public key and update .sops.yaml
age-keygen -y /var/lib/sops-nix/key.txt

# Edit secrets
sops secrets/secrets.yaml

# Rebuild to apply secrets
sudo nixos-rebuild switch --flake .#framework
```

### Home Manager Setup

```bash
# Switch to personal user
su - personal

# Initial home-manager setup
home-manager switch --flake ~/Documents/GitHub/NixOS-config#personal@framework

# For work user
su - work
home-manager switch --flake ~/Documents/GitHub/NixOS-config#work@framework
```

### Flatpak Setup

```bash
# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Tailscale Setup

```bash
# Login to Tailscale
sudo tailscale up
```

## Updating the System

```bash
# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#framework

# Rebuild home (as each user)
home-manager switch --flake .#personal@framework
home-manager switch --flake .#work@framework
```

## Troubleshooting

### Boot Issues

If the system fails to boot:

1. Boot from NixOS ISO
2. Mount existing partitions
3. Chroot and rebuild

```bash
sudo cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
sudo mount /dev/mapper/cryptroot /mnt -o subvol=@
sudo mount /dev/mapper/cryptroot /mnt/home -o subvol=@home
sudo mount /dev/mapper/cryptroot /mnt/nix -o subvol=@nix
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo nixos-enter
nixos-rebuild switch --flake /path/to/config#framework
```

### Rollback

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```
