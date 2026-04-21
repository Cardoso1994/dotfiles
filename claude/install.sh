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

# ── Skills symlink ────────────────────────────────────────────────────────────

SKILLS_TARGET="$DOTFILES_CLAUDE/skills"
SKILLS_LINK="$CLAUDE_DIR/skills"

if [[ -L "$SKILLS_LINK" ]]; then
  current_target="$(readlink "$SKILLS_LINK")"
  if [[ "$current_target" != "$SKILLS_TARGET" ]]; then
    echo "Updating skills symlink: $SKILLS_LINK -> $SKILLS_TARGET"
    ln -sf "$SKILLS_TARGET" "$SKILLS_LINK"
  else
    echo "Skills symlink already correct."
  fi
elif [[ -d "$SKILLS_LINK" ]]; then
  echo "Error: $SKILLS_LINK is a real directory, not a symlink. Move it first."
  exit 1
else
  echo "Creating skills symlink: $SKILLS_LINK -> $SKILLS_TARGET"
  ln -s "$SKILLS_TARGET" "$SKILLS_LINK"
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
