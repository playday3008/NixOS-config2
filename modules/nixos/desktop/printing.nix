# modules/nixos/desktop/printing.nix
# Printing and scanning configuration
{
  pkgs,
  ...
}:
{
  # CUPS printing service
  services.printing = {
    enable = true;

    # Printer drivers
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];

    # Allow browsing network printers
    browsing = true;
    defaultShared = false;
  };

  # Avahi for network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # SANE scanning
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      sane-airscan # Driverless scanning
      hplipWithPlugin
    ];
  };

  # Scanner utilities
  environment.systemPackages = with pkgs; [
    simple-scan # Simple scanning application
    xsane # Advanced scanning
  ];

  # Add users to scanner group
  users.users.personal.extraGroups = [
    "scanner"
    "lp"
  ];
  users.users.work.extraGroups = [
    "scanner"
    "lp"
  ];
}
