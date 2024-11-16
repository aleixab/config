#!/bin/bash

# This script is designed to fetch and display the latest tag of a Git repository.
# It utilizes the `gita` tool to manage multiple repositories and `fzf` for filtering.
#
# There are two primary modes of operation:
#
# 1. Select Mode (`select` argument):
#    When called with "select" as the first argument, it uses `fzf` to provide an
#    interactive selection of repositories. The user can manually select the repository
#    from the filtered list, and the script will fetch and display its latest tag.
#    Usage: ./script_name.sh select [optional pattern for fzf]
#
# 2. Direct Mode (default):
#    When called without "select", it directly filters repositories based on the provided
#    pattern without entering the `fzf` interface. It fetches and displays the tag of the
#    best matching repository.
#    Usage: ./script_name.sh [pattern]
#
# Example Usages:
# ./script_name.sh select        - Interactive selection from all repositories.
# ./script_name.sh select repo   - Interactive selection, but pre-filtered with the pattern "repo".
# ./script_name.sh repo          - Directly fetch the tag for the best matching repository named "repo".

function fetch_latest_tag() {
  local REPO_NAME="$1"

  gita shell "$REPO_NAME" 'git fetch origin master --tags'
  gita shell "$REPO_NAME" 'git describe --tags --abbrev=0 origin/master'
}

# If "select" argument is provided, use fzf for repository selection
if [[ "$1" == "select" ]]; then
  REPO_NAME=$(gita ll IPO-repos | awk '{print $1}' | fzf -q "$2")
  if [ -z "$REPO_NAME" ]; then
    echo "No repository selected."
    exit 1
  fi
  fetch_latest_tag "$REPO_NAME"
  exit 0
fi

# Default behavior (for the "t" alias)
REPO_NAME=$(gita ll IPO-repos | awk '{print $1}' | fzf --filter="$1" | head -1)

if [ -z "$REPO_NAME" ]; then
  echo "No repository found."
  exit 1
fi

fetch_latest_tag "$REPO_NAME"

