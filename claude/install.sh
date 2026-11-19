#!/usr/bin/env bash
# Usage: ./install.sh [work|pers]   (no argument = both accounts)
# Merges settings.base.json + settings.<profile>.json into each account
# and ensures portable shared content is symlinked into each account.

set -euo pipefail

DOTFILES_CLAUDE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_PERSONAL_DIR="$HOME/.claude-personal"

# ── Profile ──────────────────────────────────────────────────────────────────

PROFILE="${1:-}"
case "$PROFILE" in
  "") PROFILES=(work pers) ;;
  work|pers) PROFILES=("$PROFILE") ;;
  *) echo "Usage: $0 [work|pers]"; exit 1 ;;
esac

for profile in "${PROFILES[@]}"; do
  if [[ ! -f "$DOTFILES_CLAUDE/settings.${profile}.json" ]]; then
    echo "Error: no settings file found for profile '$profile'"
    exit 1
  fi
done

# ── Symlinks ─────────────────────────────────────────────────────────────────

symlink_dir() {
  local target="$1"
  local link_path="$2"
  local label="$3"

  if [[ -L "$link_path" ]]; then
    current_target="$(/usr/bin/readlink "$link_path")"
    if [[ "$current_target" != "$target" ]]; then
      echo "Updating $label symlink: $link_path -> $target"
      ln -sf "$target" "$link_path"
    else
      echo "$label symlink already correct."
    fi
  elif [[ -d "$link_path" ]]; then
    echo "Error: $link_path is a real directory, not a symlink. Move it first."
    exit 1
  else
    echo "Creating $label symlink: $link_path -> $target"
    ln -s "$target" "$link_path"
  fi
}

symlink_file() {
  local target="$1"
  local link_path="$2"

  if [[ -e "$link_path" && ! -L "$link_path" ]]; then
    echo "Error: $link_path is a real file, not a symlink. Move it first."
    exit 1
  fi
  echo "Linking file: $link_path -> $target"
  ln -sfn "$target" "$link_path"
}

symlink_dir "$DOTFILES_CLAUDE/skills" "$CLAUDE_DIR/skills" "skills"
symlink_dir "$DOTFILES_CLAUDE/hooks" "$CLAUDE_DIR/hooks" "hooks"

if [[ -d "$CLAUDE_PERSONAL_DIR" ]]; then
  symlink_dir "$DOTFILES_CLAUDE/skills" "$CLAUDE_PERSONAL_DIR/skills" \
    "skills (personal account)"
  symlink_dir "$DOTFILES_CLAUDE/hooks" "$CLAUDE_PERSONAL_DIR/hooks" \
    "hooks (personal account)"
fi

# Claude-only subagents (not skills: ~/.kiro/skills is the same directory as
# skills, so a Kiro-delegation skill would also load inside Kiro).
symlink_dir "$DOTFILES_CLAUDE/agents" "$CLAUDE_DIR/agents" "agents"
if [[ -d "$CLAUDE_PERSONAL_DIR" ]]; then
  symlink_dir "$DOTFILES_CLAUDE/agents" "$CLAUDE_PERSONAL_DIR/agents" \
    "agents (personal account)"
fi

# Kiro worker wrapper used by the kiro-* subagents.
mkdir -p "$HOME/.local/bin"
symlink_file "$DOTFILES_CLAUDE/bin/kiro-worker" "$HOME/.local/bin/kiro-worker"

symlink_file "$DOTFILES_CLAUDE/keybindings.json" "$CLAUDE_DIR/keybindings.json"
if [[ -d "$CLAUDE_PERSONAL_DIR" ]]; then
  symlink_file "$DOTFILES_CLAUDE/keybindings.json" \
    "$CLAUDE_PERSONAL_DIR/keybindings.json"
fi

symlink_file "$DOTFILES_CLAUDE/statusline-command.sh" \
  "$CLAUDE_DIR/statusline-command.sh"

# Work receives the wrapper, which imports private untracked guidance. Personal
# receives only portable guidance and can never import the work-only file.
symlink_file "$DOTFILES_CLAUDE/CLAUDE.work-wrapper.md" "$CLAUDE_DIR/CLAUDE.md"
if [[ -d "$CLAUDE_PERSONAL_DIR" ]]; then
  symlink_file "$DOTFILES_CLAUDE/CLAUDE.md" \
    "$CLAUDE_PERSONAL_DIR/CLAUDE.md"
fi

# Memory lives under a project path derived from $HOME. Claude Code replaces
# every non-alphanumeric character with a dash (not just slashes), so
# /Users/marco.cardoso -> -Users-marco-cardoso. See "Where transcripts are
# stored" in https://code.claude.com/docs/en/sessions
PROJECT_KEY=$(printf '%s' "$HOME" | sed 's|[^A-Za-z0-9]|-|g')

MEMORY_LINK="$CLAUDE_DIR/projects/${PROJECT_KEY}/memory"
mkdir -p "$(dirname "$MEMORY_LINK")"
symlink_dir "$DOTFILES_CLAUDE/memory" "$MEMORY_LINK" "memory"

if [[ -d "$CLAUDE_PERSONAL_DIR" ]]; then
  MEMORY_LINK_PERSONAL="$CLAUDE_PERSONAL_DIR/projects/${PROJECT_KEY}/memory"
  mkdir -p "$(dirname "$MEMORY_LINK_PERSONAL")"
  symlink_dir "$DOTFILES_CLAUDE/memory" "$MEMORY_LINK_PERSONAL" \
    "memory (personal account)"
fi

# ── Merge settings ────────────────────────────────────────────────────────────

BASE_FILE="$DOTFILES_CLAUDE/settings.base.json"
for profile in "${PROFILES[@]}"; do
  if [[ "$profile" == "work" ]]; then
    output="$CLAUDE_DIR/settings.json"
  else
    output="$CLAUDE_PERSONAL_DIR/settings.json"
  fi
  echo "Merging settings.base.json + settings.${profile}.json -> $output"
  python3 -I "$DOTFILES_CLAUDE/merge_settings.py" "$BASE_FILE" \
    "$DOTFILES_CLAUDE/settings.${profile}.json" "$output" \
    ${DRY_RUN:+--dry-run}
done

echo "Done. Restart Claude Code for changes to take effect."
