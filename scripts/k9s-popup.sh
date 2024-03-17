if [ "$(tmux display-message -p -F "#{session_name}")" = "k9s-popup" ]; then
    tmux detach-client
else
    tmux popup -h 90% -w 90%  -d '#{pane_current_path}' -E "tmux attach -t k9s-popup || (tmux new-session -d -s k9s-popup 'tmux set-option status off; k9s' && tmux attach -t k9s-popup)"
fi

# # Check if a window with the name "k9s-window" exists
# k9s_window=$(tmux list-windows -a -F '#{window_name} #{window_id}' | grep 'k9s-window' | awk '{print $2}')
#
# if [ -n "$k9s_window" ]; then
#   # If the window exists, toggle its visibility by selecting it or the previous window
#   if [ "$(tmux display-message -p -F "#{window_name}")" = "k9s-window" ]; then
#     tmux select-window -l
#   else
#     tmux select-window -t $k9s_window
#   fi
# else
#   # If the window doesn't exist, create it and run k9s in it
#   tmux new-window -n 'k9s-window' 'k9s'
# fi
