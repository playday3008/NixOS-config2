# Secrets Management Guide

This configuration uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption for managing secrets.

## Initial Setup

### 1. Generate Age Key

```bash
# Create key directory
sudo mkdir -p /var/lib/sops-nix

# Generate age key
sudo age-keygen -o /var/lib/sops-nix/key.txt

# Set permissions
sudo chmod 600 /var/lib/sops-nix/key.txt
```

### 2. Get Public Key

```bash
# Display public key
sudo age-keygen -y /var/lib/sops-nix/key.txt
```

This will output something like:
```
age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 3. Update .sops.yaml

Edit `secrets/.sops.yaml` and replace the placeholder with your public key:

```yaml
keys:
  - &admin age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

creation_rules:
  # Paths are relative to .sops.yaml location
  - path_regex: .*\.yaml$
    key_groups:
      - age:
          - *admin
```

### 4. Create/Edit Secrets

```bash
# Run sops from inside the secrets directory
cd secrets

# Create new secrets file
sops secrets.yaml

# Or edit existing (after initial setup)
sops secrets.yaml
```

**Note**: You can also specify a custom age key file:
```bash
SOPS_AGE_KEY_FILE=/path/to/key.txt sops secrets.yaml
```

## Secrets Structure

```yaml
# secrets/secrets.yaml
personal:
    password: "$6$rounds=500000$SALT$HASH"

work:
    password: "$6$rounds=500000$SALT$HASH"

tailscale:
    authkey: "tskey-auth-xxxxx"

# Add more secrets as needed
```

## Generating Password Hashes

```bash
# Generate SHA-512 password hash
mkpasswd -m sha-512 "your-password"

# Or interactively (won't show password)
mkpasswd -m sha-512
```

## Using Secrets in NixOS

In your NixOS configuration:

```nix
# modules/nixos/security/sops.nix
{
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."personal/password" = {
      neededForUsers = true;
    };

    secrets."tailscale/authkey" = { };
  };
}

# modules/nixos/core/users.nix
{
  users.users.personal = {
    hashedPasswordFile = config.sops.secrets."personal/password".path;
  };
}
```

## Using Secrets in Home Manager

```nix
# users/personal/default.nix
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."some-api-key" = {
      sopsFile = ../../secrets/secrets.yaml;
    };
  };

  # Use the secret
  home.file.".config/app/config".text = ''
    api_key = ${config.sops.secrets."some-api-key".path}
  '';
}
```

## Adding New Secrets

1. Edit secrets file:
   ```bash
   cd secrets && sops secrets.yaml
   ```

2. Add new secret:
   ```yaml
   new_service:
       api_key: "your-api-key"
   ```

3. Reference in NixOS/home-manager config:
   ```nix
   sops.secrets."new_service/api_key" = { };
   ```

4. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#framework
   ```

## Multiple Machines / Bootstrap Problem

When installing NixOS on a new machine, sops-nix generates a new age key. This key **cannot decrypt** secrets encrypted with a different key.

### Option 1: Add new machine's key before install (recommended)

1. Boot the new machine from NixOS ISO
2. Generate age key and note public key:
   ```bash
   sudo mkdir -p /var/lib/sops-nix
   sudo age-keygen -o /var/lib/sops-nix/key.txt
   sudo age-keygen -y /var/lib/sops-nix/key.txt
   # Outputs: age1xxxnewmachinekeyxxx...
   ```

3. On your existing machine, add the new key to `secrets/.sops.yaml`:
   ```yaml
   keys:
     - &admin age1xxxadminkeyxxx...
     - &newmachine age1xxxnewmachinekeyxxx...

   creation_rules:
     - path_regex: .*\.yaml$
       key_groups:
         - age:
             - *admin
             - *newmachine
   ```

4. Re-encrypt secrets with both keys:
   ```bash
   cd secrets && sops updatekeys secrets.yaml
   ```

5. Commit and push, then install on new machine

### Option 2: Copy existing key to new machine

Before installation, copy your existing age private key to the new machine:
```bash
# On new machine (from ISO)
sudo mkdir -p /var/lib/sops-nix
# Copy key content from existing machine
sudo nano /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
```

### Per-machine secrets (advanced)

For machine-specific secrets files:

```yaml
# secrets/.sops.yaml
keys:
  - &framework age1xxxx...
  - &vm age1yyyy...

creation_rules:
  # Framework-specific secrets
  - path_regex: framework\.yaml$
    key_groups:
      - age:
          - *framework

  # VM-specific secrets
  - path_regex: vm\.yaml$
    key_groups:
      - age:
          - *vm

  # Shared secrets (all machines can decrypt)
  - path_regex: secrets\.yaml$
    key_groups:
      - age:
          - *framework
          - *vm
```

## Backup

**Important**: Back up your age key securely!

```bash
# Export key (store in password manager)
sudo cat /var/lib/sops-nix/key.txt
```

The private key is needed to decrypt secrets. If lost, you'll need to:
1. Generate new key
2. Re-encrypt all secrets
3. Update all machines

## Rotating Keys

1. Generate new key
2. Add new public key to `.sops.yaml`
3. Re-encrypt secrets:
   ```bash
   cd secrets && sops updatekeys secrets.yaml
   ```
4. Remove old key from `.sops.yaml`
5. Deploy to all machines

## Troubleshooting

### "Failed to get data key"

- Check key file exists: `ls -la /var/lib/sops-nix/key.txt`
- Check key permissions: should be `600` owned by root
- Verify public key in `.sops.yaml` matches

### Secret not available

- Ensure secret is defined in `sops.secrets`
- Check secret path matches yaml structure
- Rebuild system after adding secrets

### Editor issues with sops

Set your preferred editor:
```bash
export EDITOR=nvim
sops secrets/secrets.yaml
```
