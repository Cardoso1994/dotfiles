#!/usr/bin/env bash
# Runs after Claude writes or edits a file. Formats .py files with ruff,
# mirroring the ruff_organize_imports + ruff_format pipeline from nvim/conform.
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Skip if no file_path in this event, not a Python file, or file is gone
[[ -z "$FILE_PATH" || "$FILE_PATH" != *.py || ! -f "$FILE_PATH" ]] && exit 0

RUFF=/opt/homebrew/bin/ruff

# Organize imports first, then format (matches conform.nvim pipeline)
"$RUFF" check --select I --fix --quiet "$FILE_PATH" 2>/dev/null || true
"$RUFF" format --quiet "$FILE_PATH" 2>/dev/null || true
