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

    ./foot.nix # Terminal
    ./zsh.nix # Shell
    ./starship.nix # Prompt
    ./git.nix # Git
    ./dev.nix # Dev utils

    ./hyprland.nix # window manager
    ./gtk.nix # gtk theming
    ./obs.nix # OBS Studio
    ./ags # bar, app launcher
    ./vesktop # discord
    ./zed # zed editor
  ];

  carburetor = {
    config = {
      variant = "cool";
      accent = "pink";
    };
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
    packages = with pkgs; [ lutgen ];
  };

  programs.home-manager.enable = true;
}
