mkdir -p ~/.fzf_history

# Use ? as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='?'

# Options to fzf command
export FZF_COMPLETION_OPTS="
  --reverse
  --walker-skip .git,node_modules,target,.direnv
  --preview-window=border-left
  --info=inline"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.direnv
  --preview-window=border-left
  --preview 'bat --color=always --style=snip {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,.direnv
  --preview-window=border-left
  --preview 'tree -C {}'"

# Options for path completion (e.g. vim **<TAB>)
export FZF_COMPLETION_PATH_OPTS="
  --walker file,dir,follow,hidden
  --preview-window=border-left
  --preview 'bat --color=always --style=snip {}'"

# Options for directory completion (e.g. cd **<TAB>)
export FZF_COMPLETION_DIR_OPTS="
  --walker dir,follow
  --preview-window=border-left
  --preview 'tree -C {}'"

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
        _fzf_complete --preview-window=border-left \
          --preview 'git show {}' -- "$@" < <(
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
    --preview-window=border-left \
    --history ~/.fzf_history/code_cd \
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
    --preview-window=border-left \
    --preview "bat --color=always --style=snip {}" < <(
    git ls-files
  ))
  if [ $? -eq 0 ] && [ -n "$OUT" ]; then
    nvim "$OUT"
  fi
  zle reset-prompt
}
zle -N vimopen
bindkey '^p' vimopen

hist() {
  db=$(find "$HOME/.mozilla/firefox/" -wholename "*.default/places.sqlite" | head -1)
  cp $db /tmp/firefox-places.sqlite
  local OUT=$(fzf --reverse -m --no-preview --wrap --gap 1 --read0 \
    --history ~/.fzf_history/firefox_hist \
    --tiebreak begin,chunk < <(
  sqlite3 /tmp/firefox-places.sqlite -cmd ".mode json" \
    "select p.title, p.description, p.url from moz_places as p where LENGTH(p.title) > 3 and p.visit_count > 1 order by p.frecency DESC" \
    | jq -rj '.[] | ( .title + "\n" + .description + "\n" + .url + "\u0000")') | tail -n 1)
  if [ $? -eq 0 ] && [ -n "$OUT" ]; then
    firefox --new-tab $OUT
  fi
  zle reset-prompt
}
zle -N hist
bindkey '^h' hist
