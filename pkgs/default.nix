inputs: final: prev: {
  # xq = import ./xq.nix prev; # cargo vendoring changed, use upstream for now
  # webcord = import ./webcord.nix prev;
  # zed-editor = import ./zed prev;

  neovim = import ./neovim.nix {
    inherit inputs;
    pkgs = prev;
  };

  standalone = import ./standalone.nix {
    inherit inputs;
    pkgs = final;
  };
}
