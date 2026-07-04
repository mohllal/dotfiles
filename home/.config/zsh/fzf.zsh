# fzf defaults and shell-widget behavior.

command -v fzf >/dev/null 2>&1 || return

export FZF_DEFAULT_OPTS="
  --height=80%
  --layout=reverse
  --border=rounded
  --info=inline
  --marker='+'
  --pointer='>'
  --prompt='fzf> '
  --preview-window=right:60%:wrap
  --bind='ctrl-u:preview-page-up,ctrl-d:preview-page-down'
  --bind='ctrl-/:toggle-preview'
  --bind='alt-up:preview-up,alt-down:preview-down'
"

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
fi

_fzf_path_preview='
if [[ -d {} ]]; then
  eza -la --color=always --icons=always --group-directories-first --git {}
elif command -v bat >/dev/null 2>&1; then
  bat --style=numbers --color=always --line-range=:300 {}
else
  sed -n "1,300p" {}
fi
'

export FZF_CTRL_T_OPTS="
  --preview='$_fzf_path_preview'
  --bind='ctrl-y:execute-silent(echo -n {} | pbcopy)+abort'
"

export FZF_ALT_C_OPTS="
  --preview='eza -la --color=always --icons=always --group-directories-first --git {}'
"

_fzf_files_source() {
  if command -v fd >/dev/null 2>&1; then
    fd --type f --hidden --follow --exclude .git
  else
    command find . -type f -not -path '*/.git/*' 2>/dev/null
  fi
}

_fzf_dirs_source() {
  if command -v fd >/dev/null 2>&1; then
    fd --type d --hidden --follow --exclude .git
  else
    command find . -type d -not -path '*/.git/*' 2>/dev/null
  fi
}

fzf-files() {
  _fzf_files_source | fzf --multi --prompt='files> ' --preview="$_fzf_path_preview"
}

fzf-dirs() {
  _fzf_dirs_source | fzf --prompt='dirs> ' \
    --preview='eza -la --color=always --icons=always --group-directories-first --git {}'
}

fzf-open() {
  local selected
  selected="$(fzf-files)" || return
  [[ -n "$selected" ]] || return

  local -a files
  files=("${(@f)selected}")
  "${EDITOR:-nvim}" "${files[@]}"
}

fzf-cd() {
  local dir
  dir="$(fzf-dirs)" || return
  [[ -n "$dir" ]] && cd "$dir"
}

fzf-history() {
  fc -rl 1 |
    sed 's/^[[:space:]]*[0-9][0-9]*[[:space:]]*//' |
    fzf --no-sort --tac --prompt='history> ' --preview='printf "%s\n" {}'
}

fzf-processes() {
  ps -axo pid=,ppid=,user=,stat=,command= |
    fzf --prompt='processes> ' \
      --header='enter: print pid | ctrl-k: kill selected process' \
      --preview='ps -p {1} -o pid,ppid,user,stat,lstart,command 2>/dev/null' \
      --bind='ctrl-k:execute-silent(kill -TERM {1})+reload(ps -axo pid=,ppid=,user=,stat=,command=)' |
    awk '{print $1}'
}

fzf-kill() {
  local selected
  selected="$(
    ps -axo pid=,ppid=,user=,stat=,command= |
      fzf --multi --prompt='kill> ' \
        --header='tab: mark processes | enter: send TERM' \
        --preview='ps -p {1} -o pid,ppid,user,stat,lstart,command 2>/dev/null'
  )" || return

  [[ -n "$selected" ]] || return

  local -a pids
  pids=("${(@f)$(print -r -- "$selected" | awk '{print $1}')}")
  kill -TERM "${pids[@]}"
}

fzf-env() {
  env | sort | fzf --prompt='env> ' --preview='printf "%s\n" {}'
}

fzf-env-copy() {
  command -v pbcopy >/dev/null 2>&1 || {
    print -u2 "pbcopy is not available."
    return 1
  }

  local selected
  selected="$(fzf-env)" || return
  [[ -n "$selected" ]] || return

  print -rn -- "$selected" | pbcopy
}

_fzf_insert_files_widget() {
  local selected
  selected="$(fzf-files)" || return
  [[ -n "$selected" ]] || return

  local -a files
  files=("${(@f)selected}")
  LBUFFER+="${(j: :)${(q)files}}"
  zle reset-prompt
}

_fzf_cd_widget() {
  local dir
  dir="$(fzf-dirs)" || return
  [[ -n "$dir" ]] || return

  BUFFER="cd ${(q)dir}"
  zle accept-line
}

_fzf_history_widget() {
  local command
  command="$(fzf-history)" || return
  [[ -n "$command" ]] || return

  BUFFER="$command"
  CURSOR=${#BUFFER}
  zle reset-prompt
}

_fzf_env_widget() {
  local selected name
  selected="$(fzf-env)" || return
  [[ -n "$selected" ]] || return

  name="${selected%%=*}"
  LBUFFER+="\${$name}"
  zle reset-prompt
}

if [[ -o interactive ]]; then
  zle -N _fzf_insert_files_widget
  zle -N _fzf_cd_widget
  zle -N _fzf_history_widget
  zle -N _fzf_env_widget

  bindkey '^X^F' _fzf_insert_files_widget
  bindkey '^X^D' _fzf_cd_widget
  bindkey '^X^H' _fzf_history_widget
  bindkey '^X^E' _fzf_env_widget
fi

alias ff='fzf-files'
alias ffo='fzf-open'
alias fcd='fzf-cd'
alias fh='fzf-history'
alias fp='fzf-processes'
alias fk='fzf-kill'
alias fev='fzf-env'
