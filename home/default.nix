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

    ./foot.nix # terminal
    ./zsh.nix # terminal shell
    ./starship.nix # prompt

    # doesn't support background tasks :(
    ./nushell.nix

    ./git.nix # git
    ./dev.nix # dev utils

    ./hyprland.nix # window manager
    ./gtk.nix # gtk theming
    ./eww.nix # bar

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
