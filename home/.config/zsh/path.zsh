# Keep PATH entries unique while preserving order.
typeset -U path PATH

_zsh_path_prepend() {
  [[ -d "$1" ]] && path=("$1" $path)
}

_zsh_path_prepend "$HOME/.local/bin"

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
_zsh_path_prepend "$PYENV_ROOT/bin"

export PATH
unfunction _zsh_path_prepend
