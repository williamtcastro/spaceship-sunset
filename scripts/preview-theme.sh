#!/usr/bin/env zsh
# Render a palette preview (ANSI 24-bit color blocks) for set_theme's fzf
# picker. Called as `preview-theme.sh <theme-name>`. Emits one accent row +
# one surface row so users see the palette before committing.
set -u

theme="${1:-}"
[[ -z "$theme" ]] && { print -u2 -- "usage: preview-theme.sh <theme-name>"; exit 2 }

ROOT="${SPACESHIP_SUNSET_ROOT:-${0:A:h:h}}"
theme_file="$ROOT/themes/$theme.zsh"
[[ -f "$theme_file" ]] || { print -u2 -- "theme not found: $theme"; exit 1 }

# Source palette in current shell (this script is already a subshell from
# fzf's point of view). `-f` equivalent: we avoid .zshrc by running via zsh
# shebang with no interactive flags.
source "$theme_file"

# Convert "#RRGGBB" (or "#RGB") to "R;G;B" for ANSI 24-bit escape.
hex_to_rgb() {
  local h="${1#\#}"
  if (( ${#h} == 3 )); then
    h="${h:0:1}${h:0:1}${h:1:1}${h:1:1}${h:2:1}${h:2:1}"
  fi
  print -- "$((16#${h:0:2}));$((16#${h:2:2}));$((16#${h:4:2}))"
}

block() {
  local hex="$1"
  [[ -z "$hex" ]] && return
  printf '\033[48;2;%sm    \033[0m' "$(hex_to_rgb "$hex")"
}

label() {
  local hex="$1" text="$2"
  printf '\033[38;2;%sm%s\033[0m' "$(hex_to_rgb "$hex")" "$text"
}

printf '\n  '
label "${CLR_ROSEWATER:-#ffffff}" "$THEME_NAME"
printf '\n\n'

accents=(
  "$CLR_ROSEWATER" "$CLR_FLAMINGO" "$CLR_PINK"     "$CLR_MAUVE"
  "$CLR_RED"       "$CLR_MAROON"   "$CLR_PEACH"    "$CLR_YELLOW"
  "$CLR_GREEN"     "$CLR_TEAL"     "$CLR_SKY"      "$CLR_SAPPHIRE"
  "$CLR_BLUE"      "$CLR_LAVENDER"
)
printf '  '
for c in $accents; do block "$c"; done
printf '\n\n'

surfaces=(
  "$CLR_TEXT"     "$CLR_SUBTEXT1" "$CLR_SUBTEXT0"
  "$CLR_OVERLAY2" "$CLR_OVERLAY1" "$CLR_OVERLAY0"
  "$CLR_SURFACE2" "$CLR_SURFACE1" "$CLR_SURFACE0"
  "$CLR_BASE"     "$CLR_MANTLE"   "$CLR_CRUST"
)
printf '  '
for c in $surfaces; do block "$c"; done
printf '\n\n'

# Show the text-on-base pairing so users can eyeball readability.
local tr_text tr_base
tr_text="$(hex_to_rgb "$CLR_TEXT")"
tr_base="$(hex_to_rgb "$CLR_BASE")"
printf '  \033[48;2;%sm\033[38;2;%sm  sample: the quick brown fox jumps over the lazy dog  \033[0m\n\n' "$tr_base" "$tr_text"

# Show the prompt accent wiring.
printf '  dir=%s  git=%s  exec=%s  time=%s  host=%s\n' \
  "$(label "${SPACESHIP_CLR_DIR:-#fff}" 'dir')" \
  "$(label "${SPACESHIP_CLR_GIT:-#fff}" 'git')" \
  "$(label "${SPACESHIP_CLR_EXEC:-#fff}" 'exec')" \
  "$(label "${SPACESHIP_CLR_TIME:-#fff}" 'time')" \
  "$(label "${SPACESHIP_CLR_HOST:-#fff}" 'host')"
