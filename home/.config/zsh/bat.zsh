# bat defaults and aliases.

command -v bat >/dev/null 2>&1 || return

export BAT_STYLE="${BAT_STYLE:-numbers,changes,header}"
export BAT_PAGER="${BAT_PAGER:-less -RF}"

# Everyday file viewing.
alias cat='bat --style=plain,header'
alias ccat='command cat'
alias batp='bat --style=plain'
alias batn='bat --style=numbers'
alias batdiff='bat --diff'

# Better man pages when bat can colorize them.
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
