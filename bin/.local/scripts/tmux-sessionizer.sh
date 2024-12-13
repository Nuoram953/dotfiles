#!/bin/bash

sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | tr '\n' '\n')

if [ -d "$HOME/.config/tmuxinator" ]; then
  possible_sessions=$(ls "$HOME/.config/tmuxinator" | sed 's/\.yml$//' | tr '\n' '\n')
else
  possible_sessions=""
fi

all_sessions=$(printf "%s\n%s" "$sessions" "$possible_sessions" | sort -u)

if [ -z "$all_sessions" ]; then
  echo "No tmux sessions or possible sessions found."
  exit 0
fi

echo $all_sessions

selected_session=$($all_sessions | fzf --prompt="Select or create a tmux session: " --height=10 --border --ansi)

if [ -z "$selected_session" ]; then
  echo "No session selected."
  exit 0
fi

if echo "$sessions" | grep -q "^$selected_session$"; then
  tmux attach-session -t "$selected_session"
else
  if [ -f "$HOME/.config/tmuxinator/$selected_session.yml" ]; then
    mux start "$selected_session"
  else
    tmux new-session -s "$selected_session"
  fi
fi

