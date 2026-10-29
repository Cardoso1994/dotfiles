#!/bin/bash
# PostToolUse hook: report .md/.txt lines over 80 chars back to Claude.
# Skips code fences, tables, headings and lines that are only a URL.
f=$(jq -r '.tool_input.file_path // empty')
case "$(basename "$f")" in slack_*) exit 0 ;; esac  # pasted into Slack
case "$f" in *.md|*.txt) ;; *) exit 0 ;; esac
[ -f "$f" ] || exit 0
out=$(awk '
  /^```/ {fence = !fence; next}
  fence || /^\|/ || /^#/ {next}
  length > 80 && $0 !~ /^[[:space:]]*(- )?<?https?:\/\/[^ ]*>?$/ {
    printf "%d: %d chars\n", NR, length
  }' "$f")
if [ -n "$out" ]; then
  echo "Lines over 80 chars in $f, please hard-wrap them:" >&2
  echo "$out" >&2
  exit 2
fi
