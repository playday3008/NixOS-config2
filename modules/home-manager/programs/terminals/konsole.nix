# modules/home-manager/programs/terminals/konsole.nix
# Konsole terminal emulator configuration
_:
{
  # Konsole is installed system-wide via KDE Plasma
  # This file configures user-specific settings

  # Konsole profile configuration
  xdg.configFile."konsolerc".text = ''
    [Desktop Entry]
    DefaultProfile=Default.profile

    [General]
    ConfigVersion=1

    [MainWindow]
    MenuBar=Disabled
    ToolBarsMovable=Disabled

    [TabBar]
    CloseTabOnMiddleMouseButton=true
    NewTabBehavior=PutNewTabAtTheEnd
    TabBarVisibility=ShowTabBarWhenNeeded
  '';

  # Default profile
  xdg.dataFile."konsole/Default.profile".text = ''
    [Appearance]
    ColorScheme=Breeze
    Font=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0

    [General]
    Command=/run/current-system/sw/bin/zsh
    Name=Default
    Parent=FALLBACK/

    [Interaction Options]
    AutoCopySelectedText=true
    TrimLeadingSpacesInSelectedText=true
    TrimTrailingSpacesInSelectedText=true

    [Scrolling]
    HistoryMode=2
    ScrollBarPosition=2

    [Terminal Features]
    BlinkingCursorEnabled=true
  '';
}
