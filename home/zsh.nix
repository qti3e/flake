{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    bat
    curl
    tree
    onefetch
    (fortune.override { withOffensive = true; })
  ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = false;
    history.size = 1000000;
    autocd = true;

    shellAliases = with { ls_args = "--git --icons --group-directories-first"; }; {
      ls = "eza -lh ${ls_args}";
      la = "eza -lah ${ls_args}";
      l = "eza -lah ${ls_args}";
      lg = "eza -lah ${ls_args} --git-ignore";
      cat = "bat";
      cp = "cp -i"; # Confirm before overwriting something
      df = "df -h"; # Human-readable sizes
      free = "free -m"; # Show sizes in MB
      clip = "wl-copy";
      curl = "curl -s";
      commit = "git commit";
      add = "git add";
      rebase = "git stash && git pull --rebase && git stash pop";
      ytop = "ytop -spfa";
      n = "nvim";
      c = "cargo";
      rs = "rust-script";
      wq = "exit";
      icat = "wezterm imgcat";
      fuck = "thefuck";
      switch = "sudo nixos-rebuild switch";
    };

    initExtraFirst = ''
      fpath=("$HOME/.zsh/completions" $fpath)

      # Options to fzf command
      export FZF_COMPLETION_OPTS='--border --info=inline'

      # Options for path completion (e.g. vim **<TAB>)
      export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'

      # Options for directory completion (e.g. cd **<TAB>)
      export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

      ## Options section
      setopt correct                                                  # Auto correct mistakes
      setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
      setopt nocaseglob                                               # Case insensitive globbing
      setopt rcexpandparam                                            # Array expension with parameters
      setopt nocheckjobs                                              # Don't warn about running processes when exiting
      setopt numericglobsort                                          # Sort filenames numerically when it makes sense
      setopt appendhistory                                            # Immediately append history instead of overwriting
      setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
      setopt autocd                                                   # if only directory path is entered, cd there.
      setopt inc_append_history                                       # save commands are added to the history immediately, otherwise only when shell exits.
      setopt histignorespace                                          # Don't save commands that start with space

      # completion options
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      zstyle ':completion:*' menu select
      zstyle ':completion:*' completer _extensions _complete _approximate
      zstyle ':completion:*' file-list all                            # Detailed List of Files and Folders
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' rehash true                              # automatically find new executables in path
      zstyle ':completion::complete:*' gain-privileges 1
      zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 3 )) )'
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'  										  # make autosuggest a little brighter
    '';

    initExtra = ''
      function nixpkgs() {
        NIXPKGS_ALLOW_UNFREE=1 nix shell "''${@/#/nixpkgs#}"
      }

      function nixpkg() {
        PKG="$1"; shift
        NIXPKGS_ALLOW_UNFREE=1 nix run "nixpkgs#$PKG" -- $@
      }

      # foot integration
      function osc7-pwd() {
          emulate -L zsh # also sets localoptions for us
          setopt extendedglob
          local LC_ALL=C
          printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
      }

      function chpwd-osc7-pwd() {
          (( ZSH_SUBSHELL )) || osc7-pwd
      }

      add-zsh-hook -Uz chpwd chpwd-osc7-pwd

      PATH="$HOME/.deno/bin:$PATH"

      # bindkey -d
      # bindkey -v
    '';
  };
}
