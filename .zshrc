export ZSH="$HOME/.oh-my-zsh"
export FZF_BASE="$HOME/.config/.fzf"
COLORTERM="truecolor"

######################################
#         Themes
######################################

ZSH_THEME="eastwood"

#Better for vim keybindings
KEYTIMEOUT=20

######################################
#         Plugins
######################################

plugins=(
  git 
  zsh-vi-mode
  fzf
  kubectl
  rust
)

source $ZSH/oh-my-zsh.sh
autoload -Uz compinit && compinit

######################################
#         Aliases
######################################

alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cport='sudo lsof -PiTCP -sTCP:LISTEN'


######################################
#         Vim configuration
######################################

# Enable vim keybindings in zsh
 bindkey -v
 bindkey -M vicmd k up-line-or-search
 bindkey -M vicmd j down-line-or-search
 bindkey jk vi-cmd-mode

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# Setting nvim as default editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

autoload -Uz history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey -M vicmd '^[[A' history-beginning-search-backward-end \
                 '^[OA' history-beginning-search-backward-end \
                 '^[[B' history-beginning-search-forward-end \
                 '^[OB' history-beginning-search-forward-end
bindkey -M viins '^[[A' history-beginning-search-backward-end \
                 '^[OA' history-beginning-search-backward-end \
                 '^[[B' history-beginning-search-forward-end \
                 '^[OB' history-beginning-search-forward-end

######################################
#         FZF configuration
######################################
#
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add theme to FZF
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FZF_DEFAULT_COMMAND="fd --hidden --follow . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '.git' . $HOME"

zle     -N   fzy-history-widget
bindkey -M viins "^R" fzy-history-widget

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}


######################################
#         Z script configuration
######################################

. $HOME/.config/scripts/z.sh

unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz() {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
}

alias j=z
alias jj=zz

######################################
#  Enable kubernetes completion
######################################

source <(kubectl completion zsh)

######################################
#  Script chrome bookmarks FZF
######################################

alias b=$HOME/.config/scripts/b.rb

# Replace cat with bat
alias bat=batcat
alias cat=bat

alias gita="python3 -m gita"
#  Gita autocompletion
source $HOME/.config/scripts/gita_autocompletions.zsh

# Add go to the path
export PATH=$PATH:/usr/local/go/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
