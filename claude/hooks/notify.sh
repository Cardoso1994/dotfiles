#!/usr/bin/env bash
# Runs on Claude's Notification event (needs permission, or is waiting for
# input). Desktop notification: osascript on macOS, notify-send (dunst) on
# Linux. Never fails the session if no notifier is installed.
set -uo pipefail

INPUT=$(cat)

MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude Code needs your attention"')
TITLE="Claude Code ($(basename "$(echo "$INPUT" | jq -r '.cwd // empty')"))"

case "$(uname -s)" in
  Darwin)
    osascript -e 'on run {t, m}' \
      -e 'display notification m with title t' \
      -e 'end run' "$TITLE" "$MESSAGE" >/dev/null 2>&1
    ;;
  Linux)
    command -v notify-send >/dev/null 2>&1 &&
      notify-send "$TITLE" "$MESSAGE"
    ;;
esac

exit 0
