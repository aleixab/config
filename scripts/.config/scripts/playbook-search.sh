#!/usr/bin/env bash
set -euo pipefail

find_all="fd --type f --hidden --no-ignore --glob .playbook.sh $HOME"
find_content="rg --glob '.playbook.sh' --hidden --no-ignore -l"

mode="name"
query=""

while true; do
  if [ "$mode" = "name" ]; then
    result=$(eval "$find_all" 2>/dev/null \
      | fzf \
          --query "$query" \
          --prompt 'name> ' \
          --header 'ctrl-r: switch to content search' \
          --preview 'batcat --color=always {}' \
          --preview-window 'right:60%:wrap' \
          --print-query \
          --expect=ctrl-r) || break
  else
    result=$(eval "$find_all" 2>/dev/null \
      | fzf \
          --query "$query" \
          --prompt 'content> ' \
          --header 'ctrl-n: switch to name search' \
          --preview 'batcat --color=always {}' \
          --preview-window 'right:60%:wrap' \
          --disabled \
          --bind "change:reload:[ -z {q} ] && $find_all 2>/dev/null || $find_content {q} $HOME 2>/dev/null || true" \
          --print-query \
          --expect=ctrl-n) || break
  fi

  query=$(echo "$result" | sed -n '1p')
  key=$(echo "$result" | sed -n '2p')
  selected=$(echo "$result" | sed -n '3p')

  if [ "$key" = "ctrl-r" ]; then
    mode="content"
  elif [ "$key" = "ctrl-n" ]; then
    mode="name"
  elif [ -n "$selected" ]; then
    nvim "$selected"
    break
  else
    break
  fi
done
