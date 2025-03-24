{
  pkgs,
  config,
  flakeDirectory,
  ...
}:
{
  home.packages = with pkgs; [
    pamixer
  ];

  programs.eww = {
    enable = true;
    enableZshIntegration = false;
    configDir = config.lib.file.mkOutOfStoreSymlink flakeDirectory + "/home/eww";
  };
}
