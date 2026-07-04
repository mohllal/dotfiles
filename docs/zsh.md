# Zsh Configuration Guide

This setup keeps `~/.zshrc` intentionally small. It loads focused modules from `~/.config/zsh` in a predictable order.

For aliases, commands, and key bindings, see `aliases-and-keybindings.md`.

## Load Order

```text
.zshrc
├── env.zsh        # Environment variables load first.
├── path.zsh       # PATH is built before tools and plugins need it.
├── oh-my-zsh.zsh  # Oh My Zsh options load before Oh My Zsh libraries/plugins.
├── fzf.zsh        # fzf defaults load before fzf widgets and completion use them.
├── completion.zsh # Completion styles load before plugin initialization.
├── plugins.zsh    # zplug loads prompt, Oh My Zsh libraries/plugins, and completion plugins.
├── tools.zsh      # Tool initialization runs after plugins are available.
├── bat.zsh        # bat aliases/defaults load after the toolchain is initialized.
├── eza.zsh        # eza aliases load after the toolchain is initialized.
├── aliases.zsh
├── prompt.zsh
└── local.zsh      # Private machine-local overrides load last
```

## Plugin Management

`plugins.zsh` owns zplug initialization and plugin declarations.

If plugins are missing:

```sh
zplug install
```

## Aliases

Aliases are organized by ownership:

- `eza.zsh`: directory listing aliases
- `bat.zsh`: file viewing aliases
- `fzf.zsh`: fzf workflow aliases
- `aliases.zsh`: general shell helpers

## Local Overrides

Use:

```sh
~/.config/zsh/local.zsh
```

for machine-specific settings, or private aliases. The repo includes `local.zsh.example` as a template, but the real `local.zsh` should stay private and untracked.

## Powerlevel10k

Powerlevel10k is installed through zplug. The generated prompt config is loaded from:

```sh
~/.p10k.zsh
```

If this file does not exist on a new machine, run:

```sh
p10k configure
```
