# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

 export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#000000,bg:-1,hl:#1c7eff
 --color=fg+:#ffa600,bg+:#ffffff,hl+:#1c7eff
 --color=info:#ff0000,prompt:#669cff,pointer:#ffa600
 --color=marker:#ff0000,spinner:#ffa600,header:#87afaf'
