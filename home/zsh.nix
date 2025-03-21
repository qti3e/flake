{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    bat
    curl
    tree
    onefetch
    (fortune.override { withOffensive = true; })
    # pure-prompt
  ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    # inline history
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    enableCompletion = true;
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
    ];

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

      # completions config
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
      zstyle ':completion:*' rehash true                              # automatically find new executables in path
      zstyle ':completion::complete:*' gain-privileges 1
      zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 3 )) )'
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'  										  # make autosuggest a little brighter

      ## Keybindings section
      bindkey -e
      bindkey '^[[7~' beginning-of-line                               # Home key
      bindkey '^[[H' beginning-of-line                                # Home key
      if [[ "''${terminfo[khome]}" != "" ]]; then
        bindkey "''${terminfo[khome]}" beginning-of-line              # [Home] - Go to beginning of line
      fi
      bindkey '^[[8~' end-of-line                                     # End key
      bindkey '^[[F' end-of-line                                      # End key
      if [[ "''${terminfo[kend]}" != "" ]]; then
        bindkey "''${terminfo[kend]}" end-of-line                     # [End] - Go to end of line
      fi
      bindkey '^[[2~' overwrite-mode                                  # Insert key
      bindkey '^[[3~' delete-char                                     # Delete key
      bindkey '^[[C'  forward-char                                    # Right key
      bindkey '^[[D'  backward-char                                   # Left key
      bindkey '^[[5~' history-beginning-search-backward               # Page up key
      bindkey '^[[6~' history-beginning-search-forward                # Page down key

      # Navigate words with ctrl+arrow keys
      bindkey '^[Oc' forward-word                                     #
      bindkey '^[Od' backward-word                                    #
      bindkey '^[[1;5D' backward-word                                 #
      bindkey '^[[1;5C' forward-word                                  #
      bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
      bindkey '^[[Z' undo                                             # Shift+tab undo last action
      WORDCHARS="*?[]~=&;!#$%^(){}<>"                                 # Let's break up words more

      # autoload -U promptinit; promptinit
      # prompt pure

      function nixpkgs() {
        NIXPKGS_ALLOW_UNFREE=1 nix shell "''${@/#/nixpkgs#}"
      }

      function nixpkg() {
        PKG="$1"; shift
        NIXPKGS_ALLOW_UNFREE=1 nix run "nixpkgs#$PKG" -- $@
      }

      PATH="$HOME/.deno/bin:$PATH"

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
    '';
    initExtra = ''
      # fortune -s
    '';
  };
}
