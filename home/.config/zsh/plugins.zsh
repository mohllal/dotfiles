# zplug plugin manager and plugin declarations.
if [[ -z "$ZPLUG_HOME" ]] && command -v brew >/dev/null 2>&1; then
  ZPLUG_HOME="$(brew --prefix zplug 2>/dev/null)"
fi

if [[ -z "$ZPLUG_HOME" ]]; then
  if [[ -f /opt/homebrew/opt/zplug/init.zsh ]]; then
    ZPLUG_HOME=/opt/homebrew/opt/zplug
  elif [[ -f /usr/local/opt/zplug/init.zsh ]]; then
    ZPLUG_HOME=/usr/local/opt/zplug
  fi
fi

export ZPLUG_HOME

if [[ ! -f "$ZPLUG_HOME/init.zsh" ]]; then
  print -u2 "zplug is not available at $ZPLUG_HOME; skipping plugins."
  return
fi

source "$ZPLUG_HOME/init.zsh"

# Prompt theme.
zplug "romkatv/powerlevel10k", as:theme, depth:1

# Oh My Zsh libraries and plugins used without loading the full framework.
zplug "lib/completion", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/functions", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/dotenv", from:oh-my-zsh
zplug "plugins/eza", from:oh-my-zsh
zplug "plugins/gh", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/k9s", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/macos", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh

# Completion and interactive quality-of-life plugins.
zplug "Aloxaf/fzf-tab", from:github, as:plugin
zplug "zsh-users/zsh-autosuggestions", from:github, as:plugin
zplug "zsh-users/zsh-completions", from:github, as:plugin
zplug "zsh-users/zsh-history-substring-search", from:github, as:plugin, defer:2

# Syntax highlighting should load after other plugins that add widgets.
zplug "zsh-users/zsh-syntax-highlighting", from:github, as:plugin, defer:3

if ! zplug check >/dev/null 2>&1; then
  print -u2 "Some zplug plugins are missing. Run: zplug install"
fi

zplug load
