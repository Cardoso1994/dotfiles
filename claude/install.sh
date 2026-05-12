#!/usr/bin/env bash
# Usage: ./install.sh [work|pers]
# Merges settings.base.json + settings.<profile>.json into ~/.claude/settings.json
# and ensures the skills symlink is in place.

set -euo pipefail

DOTFILES_CLAUDE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# ── Profile ──────────────────────────────────────────────────────────────────

PROFILE="${1:-}"
if [[ -z "$PROFILE" ]]; then
  echo "Usage: $0 [work|pers]"
  exit 1
fi

PROFILE_FILE="$DOTFILES_CLAUDE/settings.${PROFILE}.json"
if [[ ! -f "$PROFILE_FILE" ]]; then
  echo "Error: no settings file found for profile '${PROFILE}' (looked for $PROFILE_FILE)"
  exit 1
fi

# ── Symlinks (skills, hooks) ──────────────────────────────────────────────────

symlink_dir() {
  local target="$1"
  local link="$2"
  local label="$3"

  if [[ -L "$link" ]]; then
    current_target="$(readlink "$link")"
    if [[ "$current_target" != "$target" ]]; then
      echo "Updating $label symlink: $link -> $target"
      ln -sf "$target" "$link"
    else
      echo "$label symlink already correct."
    fi
  elif [[ -d "$link" ]]; then
    echo "Error: $link is a real directory, not a symlink. Move it first."
    exit 1
  else
    echo "Creating $label symlink: $link -> $target"
    ln -s "$target" "$link"
  fi
}

symlink_dir "$DOTFILES_CLAUDE/skills"  "$CLAUDE_DIR/skills"  "skills"
symlink_dir "$DOTFILES_CLAUDE/hooks"   "$CLAUDE_DIR/hooks"   "hooks"

# Memory lives under a project path derived from $HOME (slashes → dashes)
PROJECT_KEY=$(echo "$HOME" | sed 's|/|-|g')

MEMORY_LINK="$CLAUDE_DIR/projects/${PROJECT_KEY}/memory"
mkdir -p "$(dirname "$MEMORY_LINK")"
symlink_dir "$DOTFILES_CLAUDE/memory" "$MEMORY_LINK" "memory"

# Mirror memory into the personal Claude account if its data dir exists
CLAUDE_PERSONAL_DIR="$HOME/.claude-personal"
if [[ -d "$CLAUDE_PERSONAL_DIR" ]]; then
  MEMORY_LINK_PERSONAL="$CLAUDE_PERSONAL_DIR/projects/${PROJECT_KEY}/memory"
  mkdir -p "$(dirname "$MEMORY_LINK_PERSONAL")"
  symlink_dir "$DOTFILES_CLAUDE/memory" "$MEMORY_LINK_PERSONAL" "memory (personal account)"
fi

# ── Merge settings ────────────────────────────────────────────────────────────

BASE_FILE="$DOTFILES_CLAUDE/settings.base.json"
OUTPUT="$CLAUDE_DIR/settings.json"

echo "Merging settings.base.json + settings.${PROFILE}.json -> $OUTPUT"

python3 - "$BASE_FILE" "$PROFILE_FILE" "$OUTPUT" <<'EOF'
import json
import sys

def deep_merge(base, override):
    result = dict(base)
    for key, value in override.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = deep_merge(result[key], value)
        else:
            result[key] = value
    return result

base_path, profile_path, output_path = sys.argv[1], sys.argv[2], sys.argv[3]

with open(base_path) as f:
    base = json.load(f)
with open(profile_path) as f:
    profile = json.load(f)

merged = deep_merge(base, profile)

with open(output_path, "w") as f:
    json.dump(merged, f, indent=2)
    f.write("\n")
EOF

echo "Done. Restart Claude Code for changes to take effect."
