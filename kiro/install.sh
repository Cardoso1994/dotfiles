#!/usr/bin/env bash
# Usage: ./install.sh
# Installs stable Kiro configuration as symlinks into ~/.kiro. Shared content
# lives in ../claude; Kiro-owned identity, sessions, logs, and cli.json stay
# local. Set DRY_RUN=1 to show intended changes without writing.

set -euo pipefail

DOTFILES_KIRO="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_CLAUDE="$(cd "$DOTFILES_KIRO/../claude" && pwd)"
KIRO_DIR="$HOME/.kiro"

run() {
  if [[ -n "${DRY_RUN:-}" ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

# Create or fix a symlink. Existing real paths are never replaced because Kiro
# may own them; move and inspect those paths before rerunning this installer.
link() {
  local target="$1"
  local link_path="$2"

  if [[ -L "$link_path" ]]; then
    if [[ "$(/usr/bin/readlink "$link_path")" == "$target" ]]; then
      echo "ok      $link_path"
      return
    fi
    echo "update  $link_path -> $target"
    run ln -sfn "$target" "$link_path"
  elif [[ -e "$link_path" ]]; then
    echo "Error: $link_path is not a symlink. Inspect and move it first." >&2
    exit 1
  else
    echo "create  $link_path -> $target"
    run mkdir -p "$(dirname "$link_path")"
    run ln -s "$target" "$link_path"
  fi
}

# Kiro reads these stable files. Agent JSON includes only the work-only
# Clockify server; includeMcpJson makes the shared global MCP file available to
# both agents.
link "$DOTFILES_KIRO/steering" "$KIRO_DIR/steering"
link "$DOTFILES_CLAUDE/skills" "$KIRO_DIR/skills"
link "$DOTFILES_KIRO/hooks" "$KIRO_DIR/hooks"
link "$DOTFILES_KIRO/agents" "$KIRO_DIR/agents"
link "$DOTFILES_KIRO/mcp.json" "$KIRO_DIR/settings/mcp.json"

# cli.json is deliberately not symlinked. Kiro rewrites it for model and
# session preferences, while settings.json defines the small managed subset.
jq -c 'to_entries[]' "$DOTFILES_KIRO/settings.json" | while read -r entry; do
  key=$(jq -r '.key' <<<"$entry")
  value=$(jq -r '.value | if type == "string" then . else tojson end' \
    <<<"$entry")
  echo "setting $key = $value"
  run kiro-cli settings --global "$key" "$value" >/dev/null
done

echo "Done. Start Kiro manually with --agent work or --agent personal."
