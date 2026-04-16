#!/usr/bin/env bash
# Contract validator for themes/*.zsh — every palette must export the full
# set of CLR_*, surface ramp, integration hooks, and Spaceship color re-maps
# that the rest of the codebase reads. A missing export silently breaks one
# tool (and only that tool), so we check them all up front in CI.
set -euo pipefail

ROOT="${SPACESHIP_SUNSET_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
themes_dir="$ROOT/themes"

required=(
  THEME_NAME
  YAZI_FLAVOR BAT_THEME BTOP_THEME
  WEZTERM_COLOR_SCHEME
  LAZYGIT_ACTIVE_BORDER LAZYGIT_OPTIONS_TEXT LAZYGIT_CHERRY_FG
  FZF_DEFAULT_OPTS
  CLR_ROSEWATER CLR_FLAMINGO CLR_PINK CLR_MAUVE
  CLR_RED CLR_MAROON CLR_PEACH CLR_YELLOW
  CLR_GREEN CLR_TEAL CLR_SKY CLR_SAPPHIRE
  CLR_BLUE CLR_LAVENDER
  CLR_TEXT CLR_SUBTEXT1 CLR_SUBTEXT0
  CLR_OVERLAY2 CLR_OVERLAY1 CLR_OVERLAY0
  CLR_SURFACE2 CLR_SURFACE1 CLR_SURFACE0
  CLR_BASE CLR_MANTLE CLR_CRUST
  SPACESHIP_CLR_DIR SPACESHIP_CLR_GIT SPACESHIP_CLR_EXEC
  SPACESHIP_CLR_AI SPACESHIP_CLR_CLAUDE SPACESHIP_CLR_GEMINI
  SPACESHIP_CLR_TIME SPACESHIP_CLR_USER SPACESHIP_CLR_HOST
  SPACESHIP_DIR_COLOR SPACESHIP_GIT_COLOR SPACESHIP_EXEC_TIME_COLOR
  SPACESHIP_TIME_COLOR SPACESHIP_USER_COLOR SPACESHIP_HOST_COLOR
)

# CLR_* variables must be 3- or 6-digit hex literals (the integrations
# parse them directly as hex — a terminal color name like "red" would break
# the iTerm2 sRGB conversion and tmux color values).
hex_only=(
  CLR_ROSEWATER CLR_FLAMINGO CLR_PINK CLR_MAUVE
  CLR_RED CLR_MAROON CLR_PEACH CLR_YELLOW
  CLR_GREEN CLR_TEAL CLR_SKY CLR_SAPPHIRE
  CLR_BLUE CLR_LAVENDER
  CLR_TEXT CLR_SUBTEXT1 CLR_SUBTEXT0
  CLR_OVERLAY2 CLR_OVERLAY1 CLR_OVERLAY0
  CLR_SURFACE2 CLR_SURFACE1 CLR_SURFACE0
  CLR_BASE CLR_MANTLE CLR_CRUST
)

validate_theme() {
  local theme_file="$1"
  local name
  name="$(basename "$theme_file" .zsh)"
  local fail=0

  # Source the theme in an isolated zsh so previous-theme leakage can't mask a
  # missing export. `-f` skips startup files (.zshrc).
  local env_dump
  env_dump=$(zsh -f -c "
    source '$theme_file'
    for v in ${required[*]}; do
      if [[ -n \${(P)v+x} ]]; then
        printf 'SET\t%s\t%s\n' \$v \${(P)v}
      else
        printf 'UNSET\t%s\t\n' \$v
      fi
    done
  ")

  while IFS=$'\t' read -r status var value; do
    if [[ "$status" == UNSET ]]; then
      printf '  FAIL: %s missing export %s\n' "$name" "$var" >&2
      fail=1
      continue
    fi
    # Empty value counts as missing.
    if [[ -z "$value" ]]; then
      printf '  FAIL: %s exports %s but value is empty\n' "$name" "$var" >&2
      fail=1
      continue
    fi
    # Palette colors must be hex — guard against raw color names.
    for hv in "${hex_only[@]}"; do
      if [[ "$var" == "$hv" ]]; then
        if ! [[ "$value" =~ ^#[0-9A-Fa-f]{3}([0-9A-Fa-f]{3})?$ ]]; then
          printf '  FAIL: %s.%s = %s (expected #RRGGBB or #RGB)\n' "$name" "$var" "$value" >&2
          fail=1
        fi
        break
      fi
    done
  done <<<"$env_dump"

  if (( fail == 0 )); then
    printf '  OK  : %s\n' "$name"
  fi
  return "$fail"
}

overall=0
printf 'Validating %s/themes/*.zsh\n' "$ROOT"
for f in "$themes_dir"/*.zsh; do
  [[ -f "$f" ]] || continue
  validate_theme "$f" || overall=1
done

if (( overall != 0 )); then
  printf '\nTheme contract validation FAILED.\n' >&2
  exit 1
fi
printf '\nAll themes satisfy the contract.\n'
