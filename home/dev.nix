{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      neovim

      deno
      curl
      gnumake

      litemdview
      graph-easy

      inotify-tools
      nix-tree
      nix-search

      ripgrep-all
      ripgrep
      fd
      xq
      jq

      bottom
      sqlite

      kubectl
    ];

    sessionVariables = {
      EDITOR = "nvim";
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      npm_config_prefix = "$HOME/.npm/";
      PATH = "$HOME/.cargo/bin:$HOME/.npm/bin:$PATH";
    };
  };
}
