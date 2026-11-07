#!/bin/sh
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

status="$1"
response="$2"
payload="$(cat)"

ws="$(printf '%s' "$payload" | jq -r '.workspacePaths[0] // empty' 2>/dev/null)"
if [ -n "$ws" ] && [ -d "$ws" ]; then
  cd "$ws" || true
  if [ -z "$TMUX_PANE" ]; then
    pane="$(tmux list-panes -a -F '#{pane_id} #{pane_current_command} #{pane_current_path}' 2>/dev/null | awk -v p="$ws" '$3 == p && $2 != "nvim" { print $1; exit }')"
    if [ -z "$pane" ]; then
      pane="$(tmux list-panes -a -F '#{pane_id} #{pane_current_path}' 2>/dev/null | awk -v p="$ws" '$2 == p { print $1; exit }')"
    fi
    if [ -n "$pane" ]; then
      export TMUX_PANE="$pane"
    fi
  fi
fi

if command -v workmux >/dev/null 2>&1 && [ -n "$status" ]; then
  workmux set-window-status "$status" >/dev/null 2>&1
fi

printf '%s' "$response"
