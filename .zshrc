# oh-my-zsh installation path
export ZSH="$HOME/.oh-my-zsh"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# nvm installation path
export NVM_DIR="$HOME/.nvm"

# mysql installation path
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"

# postgres installation path
export PATH="/Applications/Postgres.app/Contents/Versions/13/bin:$PATH"

# Homebrew's sbin installation path
export PATH="/usr/local/sbin:$PATH"

# jdk installation path
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openjdk@11/lib"
export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"

# pyenv path
# export PATH=$(pyenv root)/shims:$PATH

# cmake installation path
export PATH="/Applications/CMake.app/Contents/bin":"$PATH"

# vscode installation path
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# poetry installation path
export PATH="$HOME/.poetry/bin:$PATH"

# R installation path
export PATH="/Library/Frameworks/R.framework/Resources/bin/:$PATH"

# oh-my-zsh theme
ZSH_THEME="robbyrussell"

# zsh-autosuggestions config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# oh-my-zsh plugins
plugins=(
	git
	colorize
	helm
	fzf
	zsh-syntax-highlighting
	zsh-autosuggestions
	kubectl
	zsh-z
	git-flow-completion
	poetry
	minikube
)

# fzf settings
export FZF_BASE="$HOME/.fzf"
export FZF_DEFAULT_COMMAND='rg --no-ignore --files --hidden -g "!{node_modules/*,.git/*}"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# starship settings
export STARSHIP_CONFIG=~/.starship.toml
export STARSHIP_CACHE=~/.starship/cache

# kubectl auth plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# aliasses
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias gt='starship toggle gcloud disabled'
alias ks='starship toggle kubernetes disabled'
#alias cat="bat"

# load gcloud sdk
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"  # This loads google-cloud-sdk
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"  # This loads google-cloud-sdk bash_completion

# load k8s completion
source "$HOME/.k9s_completion"

# load nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# load iterm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# load aws-rds-iam-auth
source $HOME/.aws-rds-iam-auth

# set starship as prompt
eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kareem/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kareem/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kareem/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kareem/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


LDFLAGS="-L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
