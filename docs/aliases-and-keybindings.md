# Aliases and Keybindings

This guide is the day-to-day reference for the shell shortcuts in this dotfiles setup.

## eza

`eza` replaces most everyday `ls` usage with prettier output, Git awareness,
icons, directory grouping, and useful sorting modes.

| Alias        | Use                                                       | Example |
|--------------|-----------------------------------------------------------|---------|
| `ls`         | Normal directory listing with icons and directories first | `ls`    |
| `l`          | Compact long-ish listing with Git status                  | `l`     |
| `ll`         | Long listing with Git status and group info               | `ll`    |
| `la`         | Detailed all-files listing with metadata and color scale  | `la`    |
| `lx`         | Extended detailed listing including extended attributes   | `lx`    |
| `l1` / `lS`  | One entry per line                                        | `l1`    |
| `ld`         | Directories only                                          | `ld`    |
| `lf`         | Files-focused listing with Git status                     | `lf`    |
| `lh`         | Hidden entries only                                       | `lh`    |
| `llm`        | Directory view sorted by modified time                    | `llm`   |
| `lsize`      | Long listing sorted by size                               | `lsize` |
| `lnew`       | Long listing sorted by newest modified                    | `lnew`  |
| `lext`       | Long listing sorted by extension                          | `lext`  |
| `lt` / `lt2` | Tree view, depth 2                                        | `lt`    |
| `lt1`        | Tree view, depth 1                                        | `lt1`   |
| `lt3`        | Tree view, depth 3                                        | `lt3`   |
| `lta`        | All-files tree, depth 2, respecting Git ignore            | `lta`   |
| `lgit`       | Long Git-aware listing                                    | `lgit`  |
| `ltree`      | Alias for `lt`                                            | `ltree` |

Examples:

```sh
ll
lnew
lt3 src
lsize ~/Downloads
```

## bat

`bat` improves file reading with syntax highlighting, headers, paging, and nicer manual pages.

| Alias     | Use                                           | Example            |
|-----------|-----------------------------------------------|--------------------|
| `cat`     | Pretty `cat` using `bat --style=plain,header` | `cat README.md`    |
| `ccat`    | Original system `cat`                         | `ccat file.txt`    |
| `batp`    | Plain bat output                              | `batp script.sh`   |
| `batn`    | bat with line numbers                         | `batn install.sh`  |
| `batdiff` | bat diff mode                                 | `batdiff file.txt` |

Manual pages are also routed through `bat`, so this becomes easier to read:

```sh
man zsh
man git
```

## fzf Commands

These are command-style helpers.

| Command        | Use                                                | Example        |
|----------------|----------------------------------------------------|----------------|
| `ff`           | Fuzzy-select files and print paths                 | `ff`           |
| `ffo`          | Fuzzy-select files and open them in `$EDITOR`      | `ffo`          |
| `fcd`          | Fuzzy-select a directory and `cd` into it          | `fcd`          |
| `fh`           | Fuzzy-search shell history                         | `fh`           |
| `fp`           | Fuzzy-select a process and print its PID           | `fp`           |
| `fk`           | Fuzzy-select one or more processes and send `TERM` | `fk`           |
| `fev`          | Fuzzy-browse environment variables                 | `fev`          |
| `fzf-env-copy` | Copy a selected `NAME=value` env var to clipboard  | `fzf-env-copy` |

Examples:

```sh
ffo
fcd
fh
fk
```

Inside most fzf pickers:

- Type to filter.
- Use arrow keys to move.
- Press `Enter` to accept.
- Press `Tab` to select multiple items when multi-select is enabled.
- Press `Ctrl-/` to toggle preview when available.

## Built-In fzf Keybindings

These come from `fzf --zsh`.

| Key      | Use                                                   |
|----------|-------------------------------------------------------|
| `Ctrl-R` | Search command history                                |
| `Ctrl-T` | Insert selected file path(s) into the current command |
| `Alt-C`  | Fuzzy-select a directory and `cd` into it             |

Examples:

```text
vim <Ctrl-T>
cd <Alt-C>
<Ctrl-R>
```

## Custom Keybindings

These are custom widgets from `fzf.zsh`. They use a `Ctrl-X` prefix to avoid overriding common shell editing keys.

| Key             | Use                                                         |
|-----------------|-------------------------------------------------------------|
| `Ctrl-X Ctrl-F` | Insert selected file path(s) into the current command       |
| `Ctrl-X Ctrl-D` | Fuzzy-select a directory and immediately `cd` into it       |
| `Ctrl-X Ctrl-H` | Search history and place the selected command on the prompt |
| `Ctrl-X Ctrl-E` | Insert an environment variable reference like `${HOME}`     |

Examples:

```text
nvim <Ctrl-X Ctrl-F>
<Ctrl-X Ctrl-D>
<Ctrl-X Ctrl-H>
echo <Ctrl-X Ctrl-E>
```

## fzf-tab Completion

`fzf-tab` upgrades normal `Tab` completion into a fuzzy picker with previews.

Try:

```sh
cd <Tab>
nvim <Tab>
git add <Tab>
git checkout <Tab>
brew info <Tab>
docker logs <Tab>
kubectl get pods <Tab>
kill <Tab>
ssh <Tab>
man <Tab>
```

Useful controls inside fzf-tab:

| Key                 | Use                                      |
|---------------------|------------------------------------------|
| `,`                 | Switch to previous completion group      |
| `.`                 | Switch to next completion group          |
| `/`                 | Continue completing deeper path segments |
| `Alt-Enter`         | Print the current query                  |
| `Ctrl-/`            | Toggle preview window                    |
| `Ctrl-U` / `Ctrl-D` | Scroll preview up/down                   |

Preview behavior:

- Directories preview with `eza`.
- Files preview with `bat` when available, otherwise `sed`.
- Git files preview diffs.
- Git branches preview recent commit history.
- Homebrew formulae preview `brew info`.
- Docker objects preview `docker inspect`.
- Kubernetes objects preview `kubectl describe` or YAML.
- Man pages preview rendered text.
- SSH hosts preview matching `~/.ssh/config` lines.
- Processes preview `ps` details.
- Environment variables preview their values.

## General Aliases

| Alias        | Use                                               |
|--------------|---------------------------------------------------|
| `reload`     | Reload `~/.zshrc`                                 |
| `path`       | Print each PATH entry on its own line             |
| `mkdir`      | Create parent directories and print created paths |
| `h`          | Show shell history                                |
| `vim` / `vi` | Use `nvim`, when installed                        |
| `search`     | `rg --smart-case`, when `rg` is installed         |
| `ducks`      | Show largest entries in the current directory     |
| `df`         | Use `duf`, when installed                         |
| `dus`        | Use `dust`, when installed                        |
| `top`        | Use `btop`, when installed                        |

Examples:

```sh
reload
path
search "TODO"
ducks
top
```

## macOS Architecture Helpers

| Command | Use                                     |
|---------|-----------------------------------------|
| `x86`   | Start an x86_64 login shell via Rosetta |
| `arm`   | Start an arm64 login shell              |

Examples:

```sh
x86
arm
```

These are useful when debugging tools that behave differently under Apple Silicon versus Rosetta.

## Recommended Beginner Workflow

Start with these:

```sh
ll
lt
cat README.md
ffo
fcd
Ctrl-R
git add <Tab>
```

Then add these as they become useful:

```sh
fh
fk
fev
Ctrl-X Ctrl-F
Ctrl-X Ctrl-D
```

You do not need to memorize everything. The aliases are designed to be discoverable by category: `l*` for listings, `f*` for fuzzy workflows, and short general helpers for common shell tasks.
