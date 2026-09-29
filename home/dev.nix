{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gh

      neovim
      tmux
      tailscale

      deno
      curl
      gnumake
      nodejs

      litemdview
      graph-easy

      glow

      inotify-tools
      nix-tree
      nix-search

      ripgrep-all
      ripgrep
      fd
      xq
      jq

      bc
      xxd

      bottom
      sqlite

      kubectl
      clamav

      zathura
      nyxt

      chromium
      vscode

      jfbview
      fbterm
    ];

    sessionVariables = {
      EDITOR = "nvim";
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      npm_config_prefix = "$HOME/.npm/";
      PATH = "$HOME/.cargo/bin:$HOME/.npm/bin:$PATH";
    };
  };
}
