{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      neovim
      tailscale

      deno
      curl
      gnumake
      nodejs_23

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
      clamav
    ];

    sessionVariables = {
      EDITOR = "nvim";
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      npm_config_prefix = "$HOME/.npm/";
      PATH = "$HOME/.cargo/bin:$HOME/.npm/bin:$PATH";
    };
  };
}
