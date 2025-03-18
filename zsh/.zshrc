# Set Oh My Zsh and FZF base directories
export ZSH="$HOME/.oh-my-zsh"
export FZF_BASE="$HOME/.fzf"
export COLORTERM="truecolor"

######################################
#              Theme
######################################

ZSH_THEME="eastwood"

KEYTIMEOUT=20

######################################
#             Plugins
######################################

plugins=(
  git
  zsh-vi-mode
  fzf
  fzf-tab
  kubectl
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

######################################
#             Aliases
######################################

alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cport='sudo lsof -PiTCP -sTCP:LISTEN'
alias bat=batcat
alias cat=batcat
alias gita="python3 -m gita"
alias b="$HOME/.config/scripts/b.rb"

######################################
#         Vim Keybindings
######################################

# Enable Vim keybindings in Zsh
bindkey -v
bindkey -M vicmd 'k' up-line-or-search
bindkey -M vicmd 'j' down-line-or-search
bindkey -M viins 'jk' vi-cmd-mode

# Set escape sequence for vi insert mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# Set default editor based on SSH connection
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# History search configuration
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd '^[[A' history-beginning-search-backward-end
bindkey -M vicmd '^[[B' history-beginning-search-forward-end
bindkey -M viins '^[[A' history-beginning-search-backward-end
bindkey -M viins '^[[B' history-beginning-search-forward-end

######################################
#             FZF Configuration
######################################

# Source FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf --zsh

# Set FZF color scheme
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Set FZF default commands
export FZF_DEFAULT_COMMAND="fd --hidden --follow . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '.git' . $HOME"

# Bind FZF history widget to Ctrl+R
zle -N fzf-history-widget
bindkey -M viins "^R" fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget

# Use fd for path and directory completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

######################################
#             Z Script
######################################

alias j=z
alias jj=zz

######################################
#        Kubernetes Completion
######################################

# Load kubectl completion
if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
fi

######################################
#         Gita Autocompletion
######################################

# Source Gita autocompletions
[ -f "$HOME/.config/scripts/gita_autocompletions.zsh" ] && source "$HOME/.config/scripts/gita_autocompletions.zsh"

######################################
#             Go Configuration
######################################

# Set Go environment variables
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

######################################
#             NVM Configuration
######################################

# Set NVM directory and load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

