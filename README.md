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
| i3, polybar, rofi, picom, dunst | ✓ | | |

Depending on the answers to `init`, any machine also gets:

- "Use YubiKeys": YubiKey packages, `~/.ssh/config`, age setup
- "Accept SSH logins": `~/.ssh/authorized_keys` from GitHub (YubiKey keys only)

YubiKey details (SSH, age, recovery): [docs/yubikey.md](docs/yubikey.md).

Machine differences live in:

- `home/.chezmoi.toml.tmpl`: per-machine data (`wsl`, `arch`, `gui`, `name`, `email`)
- `home/.chezmoiignore`: which configs each machine skips
- `*.tmpl` files: per-machine content (`dot_gitconfig.tmpl`, mise config)
- `home/.chezmoiscripts/`: install scripts

CLI tools (fzf, ripgrep, fd, bat, zoxide, age, node, go) come from mise with
pinned versions, so every machine runs the same ones. On Ubuntu/WSL neovim and
lazygit do too, because the apt versions are too old. To upgrade:
`mise outdated --bump`, then bump the pins with
`chezmoi edit ~/.config/mise/config.toml`.

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

`add`, `edit` and `re-add` commit automatically (`git.autoCommit`); push with
`chezmoi git push`.

## Routine

Every new shell warns (in yellow, with the command to run) when:

- the repo has uncommitted changes: `chezmoi cd`, then `git add -A && git commit`
- there are unpushed commits: `chezmoi git push`
- files in `~` differ from the repo: `chezmoi diff`, then `chezmoi apply`
  (keep the repo version) or `chezmoi re-add` (keep the `~` version)

Habit: when you change a config, use `chezmoi edit` (or `re-add` afterwards) and
push the same day. On the other machines, `chezmoi update` pulls and applies.

Upgrades, once a month or so:

```sh
mise outdated --bump                        # what's newer than the pins
chezmoi edit ~/.config/mise/config.toml     # bump the pins, then `chezmoi apply`
nvim +'Lazy sync'                           # update plugins
chezmoi re-add ~/.config/nvim/lazy-lock.json
chezmoi git push
```

Then `chezmoi update` on the other machines.

## Notes for later

- **Secrets**: anything sensitive (tokens, kubeconfig) goes in with
  `chezmoi add --encrypt <file>`. It is encrypted to both YubiKeys with age, so
  it's safe in this public repo; decrypting it on `apply`/`diff` needs PIN +
  touch. See [docs/yubikey.md](docs/yubikey.md).
- **Commit signing with the YubiKey** (not enabled): could be added to
  `dot_gitconfig.tmpl` for YubiKey machines only (`gpg.format = ssh`,
  `user.signingkey`, `commit.gpgsign`). Costs a touch on every commit,
  including chezmoi's auto-commits. Commands in [docs/yubikey.md](docs/yubikey.md).
