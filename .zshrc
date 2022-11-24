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