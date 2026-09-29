{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "qti3e";
        email = "hey@parsa.wtf";
      };
      gpg.format = "ssh";
      init.defaultBranch = "main";
      core.editor = "nvim";
      core.commentChar = "!";
      push.autoSetupRemote = true;
    };
    ignores = [
      ".envrc"
      ".direnv"
      "result"
      ".parsa"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      true-color = "never";

      features = "unobtrusive-line-numbers decorations";
      unobtrusive-line-numbers = {
        line-numbers = true;
        line-numbers-left-format = "{nm:>4}│";
        line-numbers-right-format = "{np:>4}│";
        line-numbers-left-style = "grey";
        line-numbers-right-style = "grey";
      };
      decorations = {
        commit-decoration-style = "bold grey box ul";
        file-style = "bold blue";
        file-decoration-style = "ul";
        hunk-header-decoration-style = "box";
      };
    };
  };
}
