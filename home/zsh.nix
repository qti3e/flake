{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    bat
    curl
    tree
    onefetch
    fd
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

    sessionVariables = {
      # Let's break up words more
      WORDCHARS = "*?[]~=&;!#$%^(){}<>";
      PATH = "$HOME/.deno/bin:$PATH";
    };

    plugins = [
      {
        name = "zsh-window-title";
        src = pkgs.fetchFromGitHub {
          owner = "olets";
          repo = "zsh-window-title";
          rev = "v1.2.0";
          sha256 = "RqJmb+XYK35o+FjUyqGZHD6r1Ku1lmckX41aXtVIUJQ=";
        };
      }
      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "25.02.0";
          sha256 = "sha256-vVsJe/MycQrwHLJOlBFLCuKuVDwQfQSMp56Y7beEUyg=";
        };
      }
    ];

    initExtraFirst = ''
      fpath=("$HOME/.zsh/completions" $fpath)

      # Use ? as the trigger sequence instead of the default **
      export FZF_COMPLETION_TRIGGER='?'

      # Options to fzf command
      export FZF_COMPLETION_OPTS="
        --walker-skip .git,node_modules,target,.direnv
        --border
        --info=inline"

      export FZF_CTRL_T_OPTS="
        --walker-skip .git,node_modules,target,.direnv
        --preview 'bat -n --color=always {}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"

      export FZF_ALT_C_OPTS="
        --walker-skip .git,node_modules,target,.direnv
        --preview 'tree -C {}'"

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
      # nixpkg command to run a package in a nix-shell
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

      # fzf based git auto completion
      _fzf_complete_git() {
          ARGS="$@"
          if [[
            $ARGS =~ 'rebase' ||
            $ARGS =~ 'show' ||
            $ARGS == 'cherry-pick'
          ]]; then
              _fzf_complete -- "$@" < <(
                git log --oneline --no-decorate --no-merges
              )
          elif [[ $ARGS =~ 'branch' || $ARGS =~ 'checkout' || $ARGS =~ 'log' ]]; then
              _fzf_complete -- "$@" < <(
                git branch --sort=-committerdate --format='%(refname:short)'
              )
          elif [[ $ARGS =~ 'add' ]]; then
              _fzf_complete "--ansi --multi" "$@" < <(
                git -c color.status=always status -s | sed -r '/  /d'
              )
          else
              eval "zle ''${fzf_default_completion: -expand-or-complete}"
          fi
      }
      _fzf_complete_git_post() {
        local cmd="$LBUFFER"
        if [[ $cmd == 'git add '* ]]; then
          sed -r 's/^ ?[^ ]+ ? //'
        else
          awk '{print $1}'
        fi
      }
      [ -n "$BASH" ] && complete -F _fzf_complete_git -o default -o bashdefault git

      # fzf: cd to ~/Code dir using Ctrl+o
      code() {
        local OUT=$(fzf --ansi --reverse \
          --preview "onefetch $HOME/Code/{} 2> /dev/null || tree -C $HOME/Code/{}" < <(
          fd --color=always -t d --follow \
                -E .git -E node_modules -E target -E .direnv -E "bazel-*" -d 2 \
                --base-directory $HOME/Code/ . ./Deno ./Personal/joe ./Personal ./
        ))
        if [ $? -eq 0 ] && [ -n "$OUT" ]; then
          cd "$HOME/Code/$OUT"
        fi
        zle reset-prompt
      }
      zle -N code
      bindkey '^o' code

      # fzf: open file in neovim (sourced from git ls-files)
      vimopen() {
        local OUT=$(fzf --ansi --reverse \
          --preview "bat --color=always {}" < <(
          git ls-files
        ))
        if [ $? -eq 0 ] && [ -n "$OUT" ]; then
          nvim "$OUT"
        fi
        zle reset-prompt
      }
      zle -N vimopen
      bindkey '^p' vimopen

      bindkey -v
    '';
  };
}
