#!/usr/bin/env bash

existing=$(tmux list-panes -F '#{pane_id}:#{@playbook_search_pane}' | grep ':1' | cut -d: -f1)

if [ -n "$existing" ]; then
  tmux kill-pane -t "$existing"
else
  new=$(tmux split-window -c '#{pane_current_path}' -vb -l 40% -P -F '#{pane_id}' "$HOME/.config/scripts/playbook-search.sh")
  tmux set-option -p -t "$new" @playbook_search_pane 1
fi
