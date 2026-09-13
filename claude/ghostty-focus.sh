#!/bin/bash
# Jump to the Claude Code session when its notification is clicked.
# Ghostty exposes no per-surface identifier in the environment (iTerm2's TERM_SESSION_ID
# has no equivalent), so the app can only be raised as a whole and tmux does the
# precise targeting.
TMUX_PANE_ID="$1"
TMUX_SOCKET="$2"

# terminal-notifier runs -execute with a launchd PATH that lacks /opt/homebrew/bin
TMUX_BIN=$(command -v tmux 2>/dev/null)
[ -x "$TMUX_BIN" ] || TMUX_BIN=/opt/homebrew/bin/tmux

osascript -e 'tell application "Ghostty" to activate'

if [ -n "$TMUX_PANE_ID" ] && [ -n "$TMUX_SOCKET" ]; then
  sleep 0.1
  session=$("$TMUX_BIN" -S "$TMUX_SOCKET" display-message -p -t "$TMUX_PANE_ID" '#{session_name}' 2>/dev/null)
  client=$("$TMUX_BIN" -S "$TMUX_SOCKET" list-clients -F '#{client_name}' 2>/dev/null | head -1)
  # select-pane alone leaves the client on whatever window it was showing
  [ -n "$session" ] && [ -n "$client" ] && "$TMUX_BIN" -S "$TMUX_SOCKET" switch-client -c "$client" -t "$session" 2>/dev/null
  "$TMUX_BIN" -S "$TMUX_SOCKET" select-window -t "$TMUX_PANE_ID" 2>/dev/null
  "$TMUX_BIN" -S "$TMUX_SOCKET" select-pane -t "$TMUX_PANE_ID" 2>/dev/null
fi
