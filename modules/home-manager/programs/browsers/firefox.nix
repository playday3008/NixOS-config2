# modules/home-manager/programs/browsers/firefox.nix
# Firefox browser configuration
{
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;

    # Firefox policies (system-wide settings)
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = false;
      DisableFormHistory = false;
      DisplayBookmarksToolbar = "newtab";
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = true;

      # Extensions to install by default
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    # Default profile
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # Search engines
      search = {
        force = true;
        default = "ddg";
        engines = {
          "ddg" = {
            name = "DuckDuckGo";
            urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
            definedAliases = [ "@d" ];
          };
          "Nix Packages" = {
            urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Options" = {
            urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
        };
      };

      # Firefox settings
      settings = {
        # General
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;

        # Security
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.tabs.firefox-view" = false;

        # Performance
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        # Wayland
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.ping-centre.telemetry" = false;
      };
    };
  };
}
