[[ -f "$HOME/aliases.zsh" ]] && source "$HOME/aliases.zsh"
[[ -f "$HOME/starship.zsh" ]] && source "$HOME/starship.zsh"
[[ -f "$HOME/nvm.zsh" ]] && source "$HOME/nvm.zsh"
[[ -f "$HOME/oh-my-zsh.zsh" ]] && source "$HOME/oh-my-zsh.zsh"
[[ -f "$HOME/conda.zsh" ]] && source "$HOME/conda.zsh"
[[ -f "$HOME/secrets.zsh" ]] && source "$HOME/secrets.zsh"

# load k8s completion
[[ -f "$HOME/.k9s_completion" ]] && source "$HOME/.k9s_completion"

# load iterm2 shell integration
[[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

# load fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# load oh-my-zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# load aws-rds-iam-auth
[[ -f "$HOME/.aws-rds-iam-auth" ]] && source "$HOME/.aws-rds-iam-auth"

# load gcloud sdk
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"  # This loads google-cloud-sdk
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"  # This loads google-cloud-sdk bash_completion

# set starship as prompt
eval "$(starship init zsh)"
