if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
    tmux detach-client
else
    tmux popup -d '#{pane_current_path}' -E "tmux attach -t popup || tmux new -s popup"
fi
