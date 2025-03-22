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
    ./zsh.nix
    ./starship.nix # Prompt

    # doesn't support background tasks :(
    ./nushell.nix

    ./git.nix # Git
    ./dev.nix # Dev utils

    ./hyprland.nix # window manager
    ./gtk.nix # gtk theming
    ./obs.nix # OBS Studio
    ./zed # zed editor

    # ./vesktop # discord
    # ./ags # bar, app launcher
  ];

  carburetor = {
    config = {
      variant = "cool";
      accent = "pink";
    };
    themes = {
      foot.enable = false;
    };
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "24.05";
    packages = with pkgs; [ lutgen ];
  };

  programs.home-manager.enable = true;
}
