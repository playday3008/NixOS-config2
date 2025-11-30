# modules/home-manager/development/languages/dotnet.nix
# .NET development environment
{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # .NET SDK (includes runtime)
    dotnet-sdk_8

    # Additional runtimes if needed
    # dotnet-runtime_8
    # dotnet-aspnetcore_8

    # Tools
    omnisharp-roslyn # C# language server
  ];

  # Environment variables for .NET
  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };

  # NuGet configuration
  xdg.configFile."NuGet/NuGet.Config".text = ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
      </packageSources>
    </configuration>
  '';
}
