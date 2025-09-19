{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # font = "Monaspacekrypton-Light:size=9, Symbols Nerd Font";
        font = "MonaspaceXenon:size=8, Symbols Nerd Font";
        dpi-aware = "yes";
        pad = "0x0 center";
        term = "xterm-256color";
      };
      colors = {
        # "background" = "192330";
        "background" = "000000";
        "foreground" = "d6d6d7";
        "regular0" = "131a24";
        "regular1" = "c94f6d";
        "regular2" = "81b29a";
        "regular3" = "f4a261";
        "regular4" = "7aa2f7";
        "regular5" = "bb9af7";
        "regular6" = "7dcfff";
        "regular7" = "a9b1d6";
        "bright0" = "414868";
        "bright1" = "c94f6d";
        "bright2" = "81b29a";
        "bright3" = "f4a261";
        "bright4" = "7aa2f7";
        "bright5" = "bb9af7";
        "bright6" = "7dcfff";
        "bright7" = "c0caf5";
      };
      mouse.hide-when-typing = "yes";
      cursor = {
        style = "beam";
        blink = "yes";
      };
    };
  };
}
