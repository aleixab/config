# dotfiles

Personal config files managed with [chezmoi](https://www.chezmoi.io/), shared
across CachyOS (i3 desktop), Ubuntu (desktop) and WSL (Ubuntu, terminal only).

## Fresh install

```sh
# CachyOS/Arch
sudo pacman -S chezmoi
# Ubuntu/WSL
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

chezmoi init --apply aleixab/config
```

`init` asks a few questions once per machine (GUI or not, git name/email) and
stores the answers in `~/.config/chezmoi/chezmoi.toml`. `apply` then runs, in order:

1. `10-install-packages`: system packages (pacman or apt), oh-my-zsh +
   plugins, TPM, zsh as login shell. Asks for sudo.
2. Writes all config files.
3. `20-install-tools`: `mise install` and tmux plugins.

Afterwards:

- Log out and back in (or open a new terminal) so zsh and mise load
- Start `nvim` once and let lazy.nvim install plugins
- If tmux plugins are missing, press `prefix + I` inside tmux

Scripts re-run automatically when they (or the mise config / tmux.conf) change.

### Machine that already has configs

Check what would be overwritten before applying:

```sh
chezmoi init aleixab/config   # no --apply
chezmoi diff
chezmoi apply                 # asks before overwriting files changed locally
```

Remove old Stow symlinks first (`stow -D -t ~ <pkg>`), otherwise chezmoi
writes through them.

## What goes where

| Config | CachyOS | Ubuntu | WSL |
|---|---|---|---|
| zsh, tmux, nvim, mise, lazygit, git, scripts | ✓ | ✓ | ✓ |
| alacritty | ✓ | ✓ | |
| i3, polybar | ✓ | | |

Machine differences live in:

- `home/.chezmoi.toml.tmpl`: per-machine data (`wsl`, `arch`, `gui`, `name`, `email`)
- `home/.chezmoiignore`: which configs each machine skips
- `*.tmpl` files: per-machine content (`dot_gitconfig.tmpl`, mise config)
- `home/.chezmoiscripts/`: install scripts

On Ubuntu/WSL, neovim, lazygit and fzf come from mise because the apt versions
are too old.

## Daily use

chezmoi copies files instead of symlinking them, so the source lives in
`~/config/home` and `~` holds the applied copies.

```sh
chezmoi edit ~/.zshrc      # edit the source, then `chezmoi apply`
chezmoi re-add             # pull in changes made directly in ~ (e.g. lazy-lock.json)
chezmoi diff               # what apply would change
chezmoi update             # git pull + apply
chezmoi cd                 # shell in the repo to commit/push
```
