{ ... }:
{
  carburetor.themes.foot.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Berkeley Mono:size=11, Symbols Nerd Font";
        dpi-aware = "yes";
        pad = "14x14 center";
        term = "xterm-256color";
      };
      colors.alpha = "0.8";
      mouse.hide-when-typing = "no";
    };
  };
}
