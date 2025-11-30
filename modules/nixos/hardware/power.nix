# modules/nixos/hardware/power.nix
# Power management configuration
{
  lib,
  ...
}:
{
  # Power profiles daemon (recommended for Framework)
  # This is typically enabled by nixos-hardware, but we ensure it here
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Disable TLP (conflicts with PPD)
  services.tlp.enable = lib.mkDefault false;

  # UPower for battery monitoring
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };

  # Thermald for thermal management (Intel)
  # Disabled for AMD systems - uncomment if using Intel
  # services.thermald.enable = true;

  # Auto-cpufreq as alternative to PPD (disabled by default)
  # Uncomment to use instead of PPD
  # services.auto-cpufreq.enable = true;
  # services.power-profiles-daemon.enable = lib.mkForce false;

  # Logind settings
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend";
  };

  # Enable suspend-then-hibernate for better battery life
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';
}
