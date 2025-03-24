{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Berkeley Mono:size=9, Symbols Nerd Font";
        dpi-aware = "yes";
        pad = "0x0 center";
        term = "xterm-256color";
      };
      colors = {
        "background" = "192330";
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

      # "regular4" = "#7aa2f7";
      # "regular5" = "#bb9af7";
      # "regular6" = "#7dcfff";
      # "regular7" = "#a9b1d6";
      # "bright0" = "#414868";
      # "bright4" = "#7aa2f7";
      # "bright5" = "#bb9af7";
      # "bright6" = "#7dcfff";
      # "bright7" = "#c0caf5";
      mouse.hide-when-typing = "no";
    };
  };
}

# black   = Shade.new("#393b44", 0.15, -0.15),
# red     = Shade.new("#c94f6d", 0.15, -0.15),
# green   = Shade.new("#81b29a", 0.10, -0.15),
# yellow  = Shade.new("#dbc074", 0.15, -0.15),
# blue    = Shade.new("#719cd6", 0.15, -0.15),
# magenta = Shade.new("#9d79d6", 0.30, -0.15),
# cyan    = Shade.new("#63cdcf", 0.15, -0.15),
# white   = Shade.new("#dfdfe0", 0.15, -0.15),
# orange  = Shade.new("#f4a261", 0.15, -0.15),
# pink    = Shade.new("#d67ad2", 0.15, -0.15),

# comment = "#738091",

# bg0     = "#131a24", -- Dark bg (status line and float)
# bg1     = "#192330", -- Default bg
# bg2     = "#212e3f", -- Lighter bg (colorcolm folds)
# bg3     = "#29394f", -- Lighter bg (cursor line)
# bg4     = "#39506d", -- Conceal, border fg

# fg0     = "#d6d6d7", -- Lighter fg
# fg1     = "#cdcecf", -- Default fg
# fg2     = "#aeafb0", -- Darker fg (status line)
# fg3     = "#71839b", -- Darker fg (line numbers, fold colums)

# sel0    = "#2b3b51", -- Popup bg, visual selection bg
# sel1    = "#3c5372", -- Popup sel bg, search bg
