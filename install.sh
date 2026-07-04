#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_HOME="$DOTFILES_DIR/home"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

ASSUME_YES=false
DRY_RUN=false
SKIP_BREW=false
SKIP_ZPLUG=false

if [[ -t 1 ]]; then
  BOLD="$(tput bold 2>/dev/null || true)"
  DIM="$(tput dim 2>/dev/null || true)"
  RED="$(tput setaf 1 2>/dev/null || true)"
  GREEN="$(tput setaf 2 2>/dev/null || true)"
  YELLOW="$(tput setaf 3 2>/dev/null || true)"
  BLUE="$(tput setaf 4 2>/dev/null || true)"
  MAGENTA="$(tput setaf 5 2>/dev/null || true)"
  RESET="$(tput sgr0 2>/dev/null || true)"
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; MAGENTA=""; RESET=""
fi

usage() {
  cat <<EOF
Usage: ./install.sh [options]

Options:
  -y, --yes          Run non-interactively and accept safe defaults.
      --dry-run      Print what would happen without changing files.
      --skip-brew    Skip Homebrew installation and brew bundle.
      --skip-zplug   Skip zplug plugin installation.
  -h, --help         Show this help message.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes|--non-interactive)
      ASSUME_YES=true
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    --skip-brew)
      SKIP_BREW=true
      ;;
    --skip-zplug)
      SKIP_ZPLUG=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf '%s\n' "${RED}Unknown option:${RESET} $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

say() {
  printf '%b\n' "$*"
}

section() {
  say ""
  say "${BOLD}${BLUE}▶ $*${RESET}"
}

success() {
  say "${GREEN}✓${RESET} $*"
}

warn() {
  say "${YELLOW}!${RESET} $*"
}

fail() {
  say "${RED}✗${RESET} $*" >&2
  exit 1
}

run() {
  say "${DIM}$ $*${RESET}"
  if [[ "$DRY_RUN" == true ]]; then
    return 0
  fi
  "$@"
}

confirm() {
  local prompt="$1"
  local default="${2:-y}"

  if [[ "$ASSUME_YES" == true ]]; then
    say "${DIM}Auto-confirmed:${RESET} $prompt"
    return 0
  fi

  local suffix="[y/N]"
  [[ "$default" == "y" ]] && suffix="[Y/n]"

  local reply
  printf '%b ' "${MAGENTA}?${RESET} $prompt $suffix"
  if [[ -r /dev/tty ]]; then
    read -r reply </dev/tty
  else
    warn "No interactive terminal available; use --yes for non-interactive installs."
    return 1
  fi

  if [[ -z "$reply" ]]; then
    [[ "$default" == "y" ]]
    return
  fi

  [[ "$reply" =~ ^[Yy]$ ]]
}

detect_environment() {
  section "Detecting environment"

  local os_name os_version arch brew_prefix
  os_name="$(uname -s)"
  os_version="$(sw_vers -productVersion 2>/dev/null || printf 'unknown')"
  arch="$(uname -m)"
  brew_prefix="$(command -v brew >/dev/null 2>&1 && brew --prefix || printf 'not installed')"

  say "OS:        $os_name $os_version"
  say "Arch:      $arch"
  say "Shell:     ${SHELL:-unknown}"
  say "Homebrew:  $brew_prefix"
  say "Dotfiles:  $DOTFILES_DIR"

  [[ "$os_name" == "Darwin" ]] || fail "This bootstrap currently targets macOS."
}

install_xcode_tools() {
  section "Checking Apple command line tools"

  if xcode-select -p >/dev/null 2>&1; then
    success "Command line tools are installed."
    return
  fi

  warn "Apple command line tools are required for Homebrew and Git."
  if confirm "Install command line tools now?" y; then
    run xcode-select --install || true
    warn "Finish the Apple installer, then run this script again."
    exit 0
  fi
}

install_homebrew() {
  [[ "$SKIP_BREW" == true ]] && {
    warn "Skipping Homebrew steps."
    return
  }

  section "Installing Homebrew dependencies"

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew is not installed."
    if confirm "Install Homebrew now?" y; then
      if [[ "$DRY_RUN" == true ]]; then
        say "${DIM}$ /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${RESET}"
      else
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    else
      fail "Homebrew is required unless you pass --skip-brew."
    fi
  else
    success "Homebrew is installed."
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    eval "$(brew shellenv)"
  fi

  if confirm "Install packages from Brewfile?" y; then
    run brew bundle --file "$DOTFILES_DIR/Brewfile"
  fi
}

ensure_directories() {
  section "Preparing directories"
  run mkdir -p "$HOME/.config/zsh"
  run mkdir -p "$HOME/.local/bin"
  run mkdir -p "$HOME/.cache/zsh"
}

ensure_local_config() {
  section "Preparing local overrides"

  local local_config="$HOME/.config/zsh/local.zsh"
  if [[ -e "$local_config" ]]; then
    success "Local override file already exists."
    return
  fi

  say "Creating a private local override file for machine-specific settings."
  run mkdir -p "$(dirname "$local_config")"
  if [[ "$DRY_RUN" == true ]]; then
    say "${DIM}$ touch $local_config${RESET}"
  else
    cat >"$local_config" <<'EOF'
# Machine-local overrides.
#
# Keep secrets, temporary experiments, and machine-specific aliases here.
EOF
  fi
  success "Created ~/.config/zsh/local.zsh"
}

backup_path() {
  local target="$1"
  local relative="${target#$HOME/}"
  local backup="$BACKUP_DIR/$relative"

  run mkdir -p "$(dirname "$backup")"
  run mv "$target" "$backup"
  warn "Backed up $target to $backup"
}

link_file() {
  local source="$1"
  local relative="${source#$DOTFILES_HOME/}"
  local target="$HOME/$relative"

  run mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      success "$relative already linked."
      return
    fi

    if confirm "Replace existing symlink $target -> $current?" y; then
      run rm "$target"
    else
      warn "Skipped $relative"
      return
    fi
  elif [[ -e "$target" ]]; then
    if confirm "Back up and replace existing $target?" y; then
      backup_path "$target"
    else
      warn "Skipped $relative"
      return
    fi
  fi

  run ln -s "$source" "$target"
  success "Linked $relative"
}

link_dotfiles() {
  section "Linking dotfiles"
  say "Files from ${BOLD}home/${RESET} will be symlinked into ${BOLD}$HOME${RESET}."

  if ! confirm "Continue with symlinking?" y; then
    warn "Skipping symlinks."
    return
  fi

  while IFS= read -r -d '' source; do
    [[ "${source#$DOTFILES_HOME/}" == ".config/zsh/local.zsh.example" ]] && continue
    link_file "$source"
  done < <(find "$DOTFILES_HOME" -type f -print0)
}

install_oh_my_zsh() {
  section "Checking Oh My Zsh"

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    success "Oh My Zsh is already installed."
    return
  fi

  if confirm "Clone Oh My Zsh into ~/.oh-my-zsh?" y; then
    run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi
}

install_zplug_plugins() {
  [[ "$SKIP_ZPLUG" == true ]] && {
    warn "Skipping zplug plugin installation."
    return
  }

  section "Installing zplug plugins"

  if ! command -v zsh >/dev/null 2>&1; then
    warn "zsh is not available; skipping zplug install."
    return
  fi

  if confirm "Run zplug install for prompt, completions, and shell plugins?" y; then
    run zsh -ic 'source ~/.config/zsh/plugins.zsh; zplug install'
  fi
}

verify_installation() {
  section "Verifying installation"

  local missing=0
  local commands=(zsh brew git fzf eza bat fd rg)

  for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      success "$cmd found."
    else
      warn "$cmd missing."
      missing=$((missing + 1))
    fi
  done

  if [[ -f "$(brew --prefix zplug 2>/dev/null)/init.zsh" || -f /opt/homebrew/opt/zplug/init.zsh || -f /usr/local/opt/zplug/init.zsh ]]; then
    success "zplug found."
  else
    warn "zplug missing."
    missing=$((missing + 1))
  fi

  if [[ -L "$HOME/.zshrc" ]]; then
    success "$HOME/.zshrc is symlinked."
  elif [[ "$DRY_RUN" == true ]]; then
    warn "$HOME/.zshrc is not symlinked yet because this was a dry run."
  else
    warn "$HOME/.zshrc is not symlinked."
    missing=$((missing + 1))
  fi

  if [[ -f "$HOME/.p10k.zsh" ]]; then
    success "Powerlevel10k config found."
  else
    warn "No ~/.p10k.zsh found. Run 'p10k configure' after opening a new shell."
  fi

  if [[ "$missing" -eq 0 ]]; then
    success "Verification passed."
  else
    warn "Verification finished with $missing missing item(s)."
  fi
}

next_steps() {
  section "All done"
  say "${GREEN}Your dotfiles are ready.${RESET}"
  say ""
  say "Next steps:"
  say "  1. Open a new terminal, or run: ${BOLD}exec zsh${RESET}"
  say "  2. If prompted by zplug, run: ${BOLD}zplug install${RESET}"
  say "  3. If the prompt needs setup, run: ${BOLD}p10k configure${RESET}"
  say "  4. Review machine-local overrides in: ${BOLD}~/.config/zsh/local.zsh${RESET}"
}

main() {
  say "${BOLD}${BLUE}Kareem's Dotfiles Bootstrap${RESET}"
  say "${DIM}Portable macOS shell setup with Homebrew, zplug, fzf, eza, bat, and Powerlevel10k.${RESET}"

  detect_environment
  install_xcode_tools
  install_homebrew
  ensure_directories
  link_dotfiles
  ensure_local_config
  install_oh_my_zsh
  install_zplug_plugins
  verify_installation
  next_steps
}

main "$@"
