# eza directory listing toolkit.

command -v eza >/dev/null 2>&1 || return

typeset -g EZA_COMMON="--icons=auto --group-directories-first"
typeset -g EZA_LONG="--long --binary --git --header"

# Familiar ls replacements.
alias ls="eza $EZA_COMMON"
alias l="eza $EZA_COMMON -lbF --git"
alias ll="eza $EZA_COMMON -lbGF --git"
alias la="eza $EZA_COMMON -lbhHigUmuSa --time-style=long-iso --git --color-scale"
alias lx="eza $EZA_COMMON -lbhHigUmuSa@ --time-style=long-iso --git --color-scale"

# Focused list views.
alias l1="eza $EZA_COMMON -1"
alias lS="eza $EZA_COMMON -1"
alias ld="eza $EZA_COMMON -lD"
alias lf="eza $EZA_COMMON -lf --git"
alias lh="eza $EZA_COMMON -ld .*"
alias llm="eza $EZA_COMMON -lbGd --git --sort=modified"
alias lsize="eza $EZA_COMMON $EZA_LONG --sort=size"
alias lnew="eza $EZA_COMMON $EZA_LONG --sort=modified"
alias lext="eza $EZA_COMMON $EZA_LONG --sort=extension"

# Tree views.
alias lt="eza $EZA_COMMON --tree --level=2"
alias lt1="eza $EZA_COMMON --tree --level=1"
alias lt2="eza $EZA_COMMON --tree --level=2"
alias lt3="eza $EZA_COMMON --tree --level=3"
alias lta="eza $EZA_COMMON --tree --all --level=2 --git-ignore"

# Useful summaries.
alias lgit="eza $EZA_COMMON $EZA_LONG --git"
alias ltree="lt"
