#!/usr/bin/env bash
# Usage: ./install.sh
# Symlinks Kiro CLI global config (~/.kiro) to this dotfiles directory and
# applies managed CLI settings. Shared content (instructions, memory, skills,
# hook scripts) lives in ../claude and is reused, not copied.
# Set DRY_RUN=1 to print what would change without touching anything.

set -euo pipefail

DOTFILES_KIRO="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_CLAUDE="$(cd "$DOTFILES_KIRO/../claude" && pwd)"
KIRO_DIR="${KIRO_HOME:-$HOME/.kiro}"

run() {
  if [[ -n "${DRY_RUN:-}" ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

# Create or fix a symlink; refuse to replace a real file or directory.
link() {
  local target="$1"
  local link="$2"

  if [[ -L "$link" ]]; then
    if [[ "$(readlink "$link")" == "$target" ]]; then
      echo "ok      $link"
      return
    fi
    echo "update  $link -> $target"
    run ln -sfn "$target" "$link"
  elif [[ -e "$link" ]]; then
    echo "Error: $link exists and is not a symlink. Move it first." >&2
    exit 1
  else
    echo "create  $link -> $target"
    run mkdir -p "$(dirname "$link")"
    run ln -s "$target" "$link"
  fi
}

# ── Symlinks ─────────────────────────────────────────────────────────────────

# Steering: Kiro-only notes plus in-repo symlinks to claude/CLAUDE.md and
# selected claude/memory files (see kiro/steering/).
link "$DOTFILES_KIRO/steering" "$KIRO_DIR/steering"

# Skills: the same directory Claude Code uses.
link "$DOTFILES_CLAUDE/skills" "$KIRO_DIR/skills"

# Hooks: JSON definitions here, scripts shared from claude/hooks.
link "$DOTFILES_KIRO/hooks" "$KIRO_DIR/hooks"

# MCP servers. Note: `kiro-cli mcp add` may replace this symlink with a
# regular file; re-run this script (it will refuse) and merge by hand.
link "$DOTFILES_KIRO/mcp.json" "$KIRO_DIR/settings/mcp.json"

# ── CLI settings ─────────────────────────────────────────────────────────────
# cli.json is rewritten by Kiro itself (/settings, /model, session filters),
# so it is not symlinked. Managed keys from settings.json are applied on top
# through `kiro-cli settings`; keys Kiro writes on its own are left alone.

jq -c 'to_entries[]' "$DOTFILES_KIRO/settings.json" | while read -r entry; do
  key=$(jq -r '.key' <<<"$entry")
  value=$(jq -r '.value | if type == "string" then . else tojson end' \
    <<<"$entry")
  echo "setting $key = $value"
  run kiro-cli settings --global "$key" "$value" >/dev/null
done

echo "Done. Start a new Kiro session and run /config to verify."
