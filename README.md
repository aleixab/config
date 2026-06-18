# dotfiles

Personal config files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Config |
|---|---|
| `alacritty` | Terminal emulator |
| `fzf` | Fuzzy finder shell integration |
| `i3` | Window manager + wallpaper |
| `lazygit` | Git TUI |
| `nvim` | Neovim |
| `polybar` | Status bar |
| `scripts` | Custom shell scripts |
| `tmux` | Terminal multiplexer |
| `zsh` | Shell (oh-my-zsh, vim keybindings, zoxide, fzf-tab) |

## Fresh install

```sh
git clone git@github.com:aleixab/config.git ~/config
cd ~/config
./bootstrap.sh
```

The bootstrap script installs system packages, oh-my-zsh and its plugins, TPM, and stows all dotfiles.

After running it:
- Open a new terminal — zsh will load automatically via alacritty
- In tmux, press `prefix + I` to install plugins

## Adding a new package

```sh
mkdir -p ~/config/<name>/.config/<name>
mv ~/.config/<name> ~/config/<name>/.config/<name>
cd ~/config && stow -t ~ <name>
git add <name> && git commit -m "add <name> config"
```
