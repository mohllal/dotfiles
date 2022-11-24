# oh-my-zsh settings
export ZSH="$HOME/.oh-my-zsh"

# nvm settings
export NVM_DIR="$HOME/.nvm"

# fzf settings
export FZF_BASE="$HOME/.fzf"
export FZF_DEFAULT_COMMAND='rg --no-ignore --files --hidden -g "!{node_modules/*,.git/*}"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# starship settings
export STARSHIP_CONFIG=~/.starship.toml
export STARSHIP_CACHE=~/.starship/cache

# gke settings
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# editor settings
export EDITOR=nano
export KUBE_EDITOR=nano

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

# mysql path
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# postgres path
export PATH="/Applications/Postgres.app/Contents/Versions/13/bin:$PATH"

# jdk path
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"

# cmake path
export PATH="/Applications/CMake.app/Contents/bin":"$PATH"

# vscode path
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# R path
export PATH="/Library/Frameworks/R.framework/Resources/bin/:$PATH"

# poetry path
export PATH="$HOME/.poetry/bin:$PATH"
