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
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - *admin
```

### 4. Create/Edit Secrets

```bash
# Create new secrets file
sops secrets/secrets.yaml

# Or edit existing (after initial setup)
sops secrets/secrets.yaml
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
   sops secrets/secrets.yaml
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

## Multiple Machines

For multiple machines with different keys:

```yaml
# .sops.yaml
keys:
  - &framework age1xxxx...
  - &server age1yyyy...

creation_rules:
  # Framework-specific secrets
  - path_regex: secrets/framework\.yaml$
    key_groups:
      - age:
          - *framework

  # Server-specific secrets
  - path_regex: secrets/server\.yaml$
    key_groups:
      - age:
          - *server

  # Shared secrets (both can decrypt)
  - path_regex: secrets/shared\.yaml$
    key_groups:
      - age:
          - *framework
          - *server
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
   sops updatekeys secrets/secrets.yaml
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
