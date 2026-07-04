# Powerlevel10k instant prompt must stay near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g ZSH_CONFIG_DIR="${ZSH_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"

_zsh_source() {
  [[ -r "$1" ]] && source "$1"
}

_zsh_source "$ZSH_CONFIG_DIR/env.zsh"
_zsh_source "$ZSH_CONFIG_DIR/path.zsh"
_zsh_source "$ZSH_CONFIG_DIR/oh-my-zsh.zsh"
_zsh_source "$ZSH_CONFIG_DIR/fzf.zsh"
_zsh_source "$ZSH_CONFIG_DIR/completion.zsh"
_zsh_source "$ZSH_CONFIG_DIR/plugins.zsh"
_zsh_source "$ZSH_CONFIG_DIR/tools.zsh"
_zsh_source "$ZSH_CONFIG_DIR/bat.zsh"
_zsh_source "$ZSH_CONFIG_DIR/eza.zsh"
_zsh_source "$ZSH_CONFIG_DIR/aliases.zsh"
_zsh_source "$ZSH_CONFIG_DIR/prompt.zsh"
_zsh_source "$ZSH_CONFIG_DIR/local.zsh"

unfunction _zsh_source
