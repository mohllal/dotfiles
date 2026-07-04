# Completion and fzf-tab behavior.

# Make Homebrew-provided completion functions available before compinit runs.
typeset -U fpath FPATH
if command -v brew >/dev/null 2>&1; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# General completion polish.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu no

zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,stat,command'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

if [[ -r "$HOME/.ssh/config" ]]; then
  typeset -a _zsh_ssh_hosts
  _zsh_ssh_hosts=("${(@f)$(awk '/^Host / { for (i = 2; i <= NF; i++) if ($i !~ /\*/) print $i }' "$HOME/.ssh/config" 2>/dev/null)}")
  zstyle ':completion:*:hosts' hosts "${_zsh_ssh_hosts[@]}"
  unset _zsh_ssh_hosts
fi

if [[ -n "$LS_COLORS" ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# fzf-tab interface.
zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border=rounded --info=inline
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' print-query alt-enter

# Generic file and directory previews.
zstyle ':fzf-tab:complete:(cd|pushd|rmdir):*' fzf-preview \
  'eza -la --color=always --icons=always --group-directories-first --git $realpath'

zstyle ':fzf-tab:complete:*:*' fzf-preview \
  '[[ -d $realpath ]] && eza -la --color=always --icons=always --group-directories-first --git $realpath || { command -v bat >/dev/null 2>&1 && bat --style=numbers --color=always --line-range=:300 $realpath || sed -n "1,300p" $realpath }'

# Git previews.
zstyle ':fzf-tab:complete:git-add:*' fzf-preview \
  'git diff --color=always -- $word 2>/dev/null'

zstyle ':fzf-tab:complete:git-diff:*' fzf-preview \
  'git diff --color=always -- $word 2>/dev/null'

zstyle ':fzf-tab:complete:git-restore:*' fzf-preview \
  'git diff --color=always -- $word 2>/dev/null'

zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'git log --color=always --oneline --decorate --graph -30 $word 2>/dev/null'

zstyle ':fzf-tab:complete:git-switch:*' fzf-preview \
  'git log --color=always --oneline --decorate --graph -30 $word 2>/dev/null'

# Runtime and package-manager previews.
zstyle ':fzf-tab:complete:brew-(install|info|uninstall|upgrade):*' fzf-preview \
  'brew info $word 2>/dev/null'

zstyle ':fzf-tab:complete:docker-(start|stop|restart|rm|inspect|logs):*' fzf-preview \
  'docker inspect $word 2>/dev/null'

zstyle ':fzf-tab:complete:kubectl:*' fzf-preview \
  'kubectl describe ${words[2]} $word 2>/dev/null || kubectl get ${words[2]} $word -o yaml 2>/dev/null'

# Documentation previews.
zstyle ':fzf-tab:complete:man:*' fzf-preview \
  'man $word 2>/dev/null | col -bx | sed -n "1,120p"'

zstyle ':fzf-tab:complete:ssh:*' fzf-preview \
  'grep -n "Host .*${word}" "$HOME/.ssh/config" 2>/dev/null'

# Shell object previews.
zstyle ':fzf-tab:complete:kill:*' fzf-preview \
  'ps -p $word -o pid,ppid,user,stat,command 2>/dev/null'

zstyle ':fzf-tab:complete:(unset|export|typeset):*' fzf-preview \
  'print -r -- ${(P)word}'
