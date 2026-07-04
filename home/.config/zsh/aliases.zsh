# General shell aliases and small helpers.

alias reload='source "$HOME/.zshrc"'
alias path='print -l $path'
alias mkdir='mkdir -pv'
alias h='history'

if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim'
fi

if command -v rg >/dev/null 2>&1; then
  alias search='rg --smart-case'
fi

if command -v du >/dev/null 2>&1; then
  alias ducks='du -cks * .[^.]* 2>/dev/null | sort -rn | head'
fi

if command -v duf >/dev/null 2>&1; then
  alias df='duf'
fi

if command -v dust >/dev/null 2>&1; then
  alias dus='dust'
fi

if command -v btop >/dev/null 2>&1; then
  alias top='btop'
fi

# Start a login shell under a specific macOS architecture.
x86() {
  env /usr/bin/arch -x86_64 /bin/zsh --login
}

arm() {
  env /usr/bin/arch -arm64 /bin/zsh --login
}
