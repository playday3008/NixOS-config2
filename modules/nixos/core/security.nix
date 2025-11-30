# modules/nixos/core/security.nix
# Security, polkit, and sudo configuration
_:
{
  # Polkit for privilege escalation
  security.polkit.enable = true;

  # Real-time kit for audio
  security.rtkit.enable = true;

  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;

    # Allow wheel group to use sudo
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "ALL";
            options = [ "SETENV" ];
          }
        ];
      }
    ];
  };

  # PAM configuration for fingerprint support
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    sddm.fprintAuth = true;
  };

  # Enable TPM2 support
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}
