#!/bin/bash

set -e

echo "==> Installing system packages..."
sudo pacman -S --noconfirm --needed stow zoxide mise fzf fd tmux neovim ripgrep lazygit rust

echo "==> Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "    oh-my-zsh already installed, skipping"
fi

echo "==> Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
  git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM/plugins/zsh-vi-mode"
else
  echo "    zsh-vi-mode already installed, skipping"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
  git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
else
  echo "    fzf-tab already installed, skipping"
fi

echo "==> Installing TPM (tmux plugin manager)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "    TPM already installed, skipping"
fi

echo "==> Stowing dotfiles..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

for pkg in zsh tmux fzf scripts nvim lazygit i3 polybar alacritty mise; do
  if [ -d "$pkg" ]; then
    stow -t ~ "$pkg" && echo "    stowed $pkg" || echo "    WARNING: $pkg stow failed (conflict?)"
  fi
done

echo "==> Installing mise runtimes (node, go)..."
mise install

echo ""
echo "Done! Open a new shell to load the config."
echo "In tmux, press prefix + I to install plugins."
