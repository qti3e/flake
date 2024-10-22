{
  pkgs,
  inputs,
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    # carburetor theming
    inputs.carburetor.homeManagerModules.default

    ./zsh.nix # Shell
    ./starship.nix # Prompt
    ./git.nix # Git
    ./dev.nix # Dev utils

    ./hyprland.nix # window manager
    ./gtk.nix # gtk theming
    ./obs.nix # OBS Studio
    ./ags # bar, app launcher
    ./wezterm # terminal
    ./vesktop # discord
    ./zed # zed editor
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
    packages = with pkgs; [ lutgen ];
  };

  programs.home-manager.enable = true;
}
