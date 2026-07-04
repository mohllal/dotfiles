# Locale and process-wide environment.
export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Keep Powerlevel10k quiet once a checked-in/generated config exists.
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Prefer Colima's Docker socket only when it exists.
if [[ -S "$HOME/.colima/default/docker.sock" ]]; then
  export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
fi

# Enable Docker BuildKit by default.
export DOCKER_BUILDKIT="${DOCKER_BUILDKIT:-1}"
