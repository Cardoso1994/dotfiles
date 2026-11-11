#!/usr/bin/env bash
# Claude Code status line, shared by both accounts.
#   model · dir (branch) · context bar
#   + work account (~/.claude):              session cost in USD
#   + personal account (~/.claude-personal): 5h and 7d usage with reset times
# Reads the status line JSON on stdin; field names checked against 2.1.322.
set -uo pipefail

INPUT=$(cat)
get() { jq -r "$1 // empty" <<<"$INPUT"; }

RESET=$'\e[0m' DIM=$'\e[2m' BOLD=$'\e[1m'
GREEN=$'\e[32m' YELLOW=$'\e[33m' RED=$'\e[31m' CYAN=$'\e[36m' MAGENTA=$'\e[35m'

# Green under 50%, yellow under 80%, red above.
color_for() {
  local p=${1%.*}
  if ((p >= 80)); then printf %s "$RED"
  elif ((p >= 50)); then printf %s "$YELLOW"
  else printf %s "$GREEN"; fi
}

# 10-cell bar for a percentage.
bar() {
  local p=${1%.*} filled i out=""
  ((p > 100)) && p=100
  filled=$(((p + 5) / 10))
  for ((i = 0; i < 10; i++)); do
    ((i < filled)) && out+="█" || out+="░"
  done
  printf %s "$out"
}

# Human time left until an epoch-seconds or ISO timestamp.
until_reset() {
  local ts=$1 epoch now left
  [[ -z "$ts" ]] && return
  if [[ "$ts" =~ ^[0-9]+$ ]]; then epoch=$ts
  else epoch=$(date -d "$ts" +%s 2>/dev/null) || return; fi
  now=$(date +%s)
  left=$((epoch - now))
  ((left < 0)) && left=0
  if ((left >= 86400)); then
    printf '%dd%dh' $((left / 86400)) $((left % 86400 / 3600))
  else
    printf '%dh%02dm' $((left / 3600)) $((left % 3600 / 60))
  fi
}

# ── Session context ──────────────────────────────────────────────────────────
MODEL=$(get '.model.display_name')
DIR=$(get '.workspace.current_dir')
DIR_NAME=$(basename "${DIR:-$PWD}")
BRANCH=$(git -C "${DIR:-$PWD}" branch --show-current 2>/dev/null)
EFFORT=$(get '.effort.level')

CTX_PCT=$(get '.context_window.used_percentage')
CTX_USED=$(get '.context_window.total_input_tokens')
CTX_SIZE=$(get '.context_window.context_window_size')

parts=()
parts+=("${BOLD}${CYAN}${MODEL:-Claude}${RESET}${EFFORT:+${DIM} ${EFFORT}${RESET}}")
parts+=("${MAGENTA}${DIR_NAME}${RESET}${BRANCH:+${DIM} (${BRANCH})${RESET}}")

if [[ -n "$CTX_PCT" ]]; then
  c=$(color_for "$CTX_PCT")
  ctx="ctx ${c}$(bar "$CTX_PCT") $(printf '%.0f' "$CTX_PCT")%${RESET}"
  if [[ -n "$CTX_USED" && -n "$CTX_SIZE" ]]; then
    ctx+="${DIM} $((CTX_USED / 1000))k/$((CTX_SIZE / 1000))k${RESET}"
  fi
  parts+=("$ctx")
fi

# ── Account-specific segment ─────────────────────────────────────────────────
window() {
  local label=$1 key=$2 pct reset c
  pct=$(get ".rate_limits.${key}.used_percentage")
  [[ -z "$pct" ]] && return
  reset=$(until_reset "$(get ".rate_limits.${key}.resets_at")")
  c=$(color_for "$pct")
  printf '%s %s%.0f%%%s%s' "$label" "$c" "$pct" "$RESET" \
    "${reset:+${DIM} ↻${reset}${RESET}}"
}

if [[ "${CLAUDE_CONFIG_DIR:-$HOME/.claude}" == *claude-personal* ]]; then
  five=$(window 5h five_hour)
  seven=$(window 7d seven_day)
  if [[ -n "$five$seven" ]]; then
    parts+=("${five}${five:+${seven:+  }}${seven}")
  else
    parts+=("${DIM}usage n/a${RESET}")
  fi
else
  COST=$(get '.cost.total_cost_usd')
  parts+=("${YELLOW}\$$(printf '%.2f' "${COST:-0}")${RESET}")
fi

sep="${DIM} │ ${RESET}"
out=""
for p in "${parts[@]}"; do out+="${out:+$sep}$p"; done
printf '%s\n' "$out"
