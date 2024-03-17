# Color key:
#   #ffffff Background
#   #efefef Current Line
#   #d6d6d6 Selection
#   #4d4d4c Foreground
#   #8e908c Comment
#   #c82829 Red
#   #f5871f Orange
#   #eab700 Yellow
#   #718c00 Green
#   #3e999f Aqua
#   #4271ae Blue
#   #8959a8 Purple



########################################
# Status bar genearl colork
########################################

set -g status-style bg=color221
setw -g window-status-current-style bg="#efefef"
setw -g window-status-current-style fg="#4271ae"


########################################
# Window Pane background 
########################################

#Windows not focused bg
setw -g window-style 'bg=#ffffff'
#Windows focused bg
setw -g window-active-style 'bg=#ffffff'
setw -g pane-active-border-style ''

## highlight activity in status bar
setw -g window-status-activity-style fg="#3e999f"
setw -g window-status-activity-style bg="#ffffff"

## pane border and colors
set -g pane-active-border-style bg=default
set -g pane-active-border-style fg="#d6d6d6"
set -g pane-border-style bg=default
set -g pane-border-style fg="#d6d6d6"

set -g clock-mode-colour "#4271ae"
set -g clock-mode-style 24

set -g message-style bg="#3e999f"
set -g message-style fg="#000000"

set -g message-command-style bg="#3e999f"
set -g message-command-style fg="#000000"

# message bar or "prompt"
set -g message-style bg="#2d2d2d"
set -g message-style fg="#cc99cc"

set -g mode-style bg="#ffffff"
set -g mode-style fg="#f5871f"

########################################
#  Right-Side Status bar
########################################

set -g status-right-length 100
set -g status-right-style fg=black
set -g status-right-style bold
set -g status-right '#[fg=#000000,bg=#ffffff] %H:%M |#[fg=#000000] %y.%m.%d '

########################################
#  Left-side Status bar
########################################


# No active one
set-window-option -g window-status-style bg=default
set-window-option -g window-status-style fg=white
set-window-option -g window-status-style none
set-window-option -g window-status-format '#[fg=#000000,bg=color221] #I#[fg=#000000,bg=#color221] #W #[default]'

# Active one

set-window-option -g window-status-current-style bold
set-window-option -g window-status-current-format '#[fg=#000000,bg=#ffffff] #I#[fg=#000000,bg=#ffffff] #W #[default]'

########################################
# Border of pane 
########################################

# active terminal yellow border, non-active white

set -g pane-border-style bg=default
set -g pane-border-style fg="#999999"
set -g pane-active-border-style fg="#f99157"
