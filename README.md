# Kareem's Dotfiles

My macOS shell setup built around Zsh, Homebrew, zplug, Oh My Zsh, Powerlevel10k, fzf, eza, and bat.

I intentionally designed this repository to be portable, readable, idempotent, and easy to bootstrap on a new machine. However, I wouldn't recommend using my dotfiles wholesale, instead, feel free to browse through the files and borrow any useful ideas or snippets that work for your own setup.

## Quick Start

```sh
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/Documents/Workspace/Personal/dotfiles
cd ~/Documents/Workspace/Personal/dotfiles
./install.sh
```

For automation:

```sh
./install.sh --yes
```

Preview without changing anything:

```sh
./install.sh --dry-run
```

## Repository Layout

```text
.
├── Brewfile
├── install.sh
├── docs/
│   ├── aliases-and-keybindings.md
│   └── zsh.md
└── home/
    ├── .zprofile
    ├── .zshrc
    └── .config/
        └── zsh/
            ├── aliases.zsh
            ├── bat.zsh
            ├── completion.zsh
            ├── env.zsh
            ├── eza.zsh
            ├── fzf.zsh
            ├── local.zsh.example
            ├── oh-my-zsh.zsh
            ├── path.zsh
            ├── plugins.zsh
            ├── prompt.zsh
            └── tools.zsh
```

The `home/` directory mirrors paths under `$HOME`. The installer symlinks each
file into place, backing up existing files before replacing them.

## Bootstrap Script

`install.sh` performs the full setup:

1. Detects macOS version, CPU architecture, shell, Homebrew prefix, and repo path.
2. Checks Apple command line tools.
3. Installs Homebrew when needed.
4. Installs packages, casks, and fonts from `Brewfile`.
5. Creates required directories.
6. Symlinks dotfiles from `home/` into `$HOME`.
7. Installs Oh My Zsh.
8. Installs zplug plugins.
9. Verifies the installation and prints next steps.

Options:

```text
--yes          Non-interactive mode for automation
--dry-run      Show what would happen without changing files
--skip-brew    Skip Homebrew and Brewfile steps
--skip-zplug   Skip zplug plugin installation
--help         Show usage
```

## Zsh Modules

The shell setup is split by concern:

- `env.zsh`: locale and process-wide environment
- `path.zsh`: PATH construction
- `oh-my-zsh.zsh`: non-plugin Oh My Zsh options and commented reference settings
- `fzf.zsh`: fzf defaults, commands, widgets, and aliases
- `completion.zsh`: zstyle completion and fzf-tab behavior
- `plugins.zsh`: zplug and plugin declarations
- `tools.zsh`: tool initialization for fzf, pyenv, and nvm
- `bat.zsh`: bat defaults and aliases
- `eza.zsh`: directory listing aliases
- `aliases.zsh`: general shell helpers
- `prompt.zsh`: Powerlevel10k config loader
- `local.zsh.example`: template for private machine-local overrides

See `docs/zsh.md` for the module layout and `docs/aliases-and-keybindings.md`
for the day-to-day command, alias, and keybinding reference.

## After Installing

Open a new terminal or run:

```sh
exec zsh
```

If zplug reports missing plugins:

```sh
zplug install
```

If Powerlevel10k needs configuration:

```sh
p10k configure
```

> [!TIP]
> `~/.config/zsh/local.zsh` is created by the installer as a private machine-local file. It is sourced by `.zshrc` but not tracked by this repository. Keep secrets and one-off machine overrides there.
