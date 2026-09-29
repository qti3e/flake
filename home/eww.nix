{
  pkgs,
  config,
  flakeDirectory,
  ...
}:
{
  home.packages = with pkgs; [
    pamixer
    eww
  ];

  # Out of store symlink for eww config
  xdg.configFile."eww".source = config.lib.file.mkOutOfStoreSymlink flakeDirectory + "/home/eww";
}
