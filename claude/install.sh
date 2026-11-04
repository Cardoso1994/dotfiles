#!/usr/bin/env bash
# Usage: ./install.sh [work|pers]   (no argument = both accounts)
# Merges settings.base.json + settings.<profile>.json into each account
# and ensures the skills symlink is in place.

set -euo pipefail

DOTFILES_CLAUDE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# ── Profile ──────────────────────────────────────────────────────────────────

# No argument updates both accounts; "work" or "pers" updates just one.
PROFILE="${1:-}"
case "$PROFILE" in
  "") PROFILES=(work pers) ;;
  work|pers) PROFILES=("$PROFILE") ;;
  *) echo "Usage: $0 [work|pers]"; exit 1 ;;
esac

for p in "${PROFILES[@]}"; do
  if [[ ! -f "$DOTFILES_CLAUDE/settings.${p}.json" ]]; then
    echo "Error: no settings file found for profile '${p}'"
    exit 1
  fi
done

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

# Keybindings are one shared file for both accounts
symlink_file() {
  local target="$1"
  local link="$2"

  if [[ -e "$link" && ! -L "$link" ]]; then
    echo "Error: $link is a real file, not a symlink. Move it first."
    exit 1
  fi
  echo "Linking file: $link -> $target"
  ln -sfn "$target" "$link"
}

# Hooks are shared with the personal account as well
if [[ -d "$HOME/.claude-personal" ]]; then
  symlink_dir "$DOTFILES_CLAUDE/hooks" "$HOME/.claude-personal/hooks" \
    "hooks (personal account)"
fi

symlink_file "$DOTFILES_CLAUDE/keybindings.json" "$CLAUDE_DIR/keybindings.json"
if [[ -d "$HOME/.claude-personal" ]]; then
  symlink_file "$DOTFILES_CLAUDE/keybindings.json" \
    "$HOME/.claude-personal/keybindings.json"
fi

# Global instructions are one shared file for both accounts
symlink_file "$DOTFILES_CLAUDE/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
if [[ -d "$HOME/.claude-personal" ]]; then
  symlink_file "$DOTFILES_CLAUDE/CLAUDE.md" "$HOME/.claude-personal/CLAUDE.md"
fi

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
# Managed settings win on conflicts; keys only present in the live file (the
# ones Claude Code writes itself) are kept. Set DRY_RUN=1 to print diffs only.

BASE_FILE="$DOTFILES_CLAUDE/settings.base.json"

for p in "${PROFILES[@]}"; do
  if [[ "$p" == "work" ]]; then
    OUTPUT="$HOME/.claude/settings.json"
  else
    OUTPUT="$HOME/.claude-personal/settings.json"
  fi
  echo "Merging settings.base.json + settings.${p}.json -> $OUTPUT"
  python3 -I "$DOTFILES_CLAUDE/merge_settings.py" "$BASE_FILE" \
    "$DOTFILES_CLAUDE/settings.${p}.json" "$OUTPUT" ${DRY_RUN:+--dry-run}
done

echo "Done. Restart Claude Code for changes to take effect."
