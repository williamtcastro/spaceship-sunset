#!/usr/bin/env bash
# WCAG contrast check for each palette's primary text/background pair.
# Uses the WCAG 2.1 relative-luminance formula. Warns on <4.5 (AA body),
# fails on <3.0 (below AA large-text minimum — unreadable in practice).
#
# Flags:
#   --strict    treat <4.5 as failure (not warning). Default: warn-only.

set -euo pipefail

ROOT="${SPACESHIP_SUNSET_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
themes_dir="$ROOT/themes"
strict=0
for arg in "$@"; do
  case "$arg" in
    --strict) strict=1 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

# Compute WCAG contrast ratio for two hex colors via awk.
# Caller passes #RRGGBB, we linearize each channel then apply L = 0.2126R + 0.7152G + 0.0722B
# and ratio = (Lbright + 0.05) / (Ldark + 0.05).
contrast_ratio() {
  local fg="${1#\#}" bg="${2#\#}"
  # Convert each pair of hex chars to decimal up front — portable awk has no
  # hex parser, so we pre-compute with bash's built-in $((16#..)).
  local fr fg_ fb br bg_ bb
  fr=$((16#${fg:0:2}))
  fg_=$((16#${fg:2:2}))
  fb=$((16#${fg:4:2}))
  br=$((16#${bg:0:2}))
  bg_=$((16#${bg:2:2}))
  bb=$((16#${bg:4:2}))
  awk -v fr="$fr" -v fg="$fg_" -v fb="$fb" \
      -v br="$br" -v bg="$bg_" -v bb="$bb" '
    function srgb_lum(c,   lin) {
      c = c / 255.0
      if (c <= 0.03928) lin = c / 12.92
      else              lin = ((c + 0.055) / 1.055) ^ 2.4
      return lin
    }
    BEGIN {
      lf = 0.2126 * srgb_lum(fr) + 0.7152 * srgb_lum(fg) + 0.0722 * srgb_lum(fb)
      lb = 0.2126 * srgb_lum(br) + 0.7152 * srgb_lum(bg) + 0.0722 * srgb_lum(bb)
      if (lf > lb) printf "%.2f\n", (lf + 0.05) / (lb + 0.05)
      else         printf "%.2f\n", (lb + 0.05) / (lf + 0.05)
    }
  '
}

overall=0
printf 'WCAG contrast (CLR_TEXT on CLR_BASE)\n'
printf '  target: >= 4.5 for normal body text (WCAG 2.1 AA)\n'
printf '  strict mode: %s\n\n' "$( (( strict == 1 )) && echo on || echo off )"

for f in "$themes_dir"/*.zsh; do
  [[ -f "$f" ]] || continue
  name="$(basename "$f" .zsh)"

  # Source palette in a sub-zsh to extract CLR_TEXT + CLR_BASE without leakage.
  read -r text base < <(zsh -f -c "
    source '$f'
    print -r -- \"\$CLR_TEXT \$CLR_BASE\"
  ")

  if [[ -z "$text" || -z "$base" ]]; then
    printf '  SKIP: %-30s (missing CLR_TEXT or CLR_BASE)\n' "$name"
    continue
  fi

  # Expand 3-digit hex to 6-digit.
  expand_hex() {
    local h="${1#\#}"
    if (( ${#h} == 3 )); then
      printf '%s%s%s%s%s%s' "${h:0:1}" "${h:0:1}" "${h:1:1}" "${h:1:1}" "${h:2:1}" "${h:2:1}"
    else
      printf '%s' "$h"
    fi
  }
  text_x="$(expand_hex "$text")"
  base_x="$(expand_hex "$base")"

  ratio=$(contrast_ratio "#$text_x" "#$base_x")

  status=OK
  # `bc` is on every macOS/Ubuntu runner; cheaper than awk math here.
  if awk -v r="$ratio" 'BEGIN { exit !(r < 3.0) }'; then
    status=FAIL
    overall=1
  elif awk -v r="$ratio" 'BEGIN { exit !(r < 4.5) }'; then
    status=WARN
    (( strict == 1 )) && overall=1
  fi

  printf '  %-4s: %-30s text=%s base=%s  ratio=%s\n' "$status" "$name" "$text" "$base" "$ratio"
done

if (( overall != 0 )); then
  printf '\nContrast check failed.\n' >&2
  exit 1
fi
printf '\nAll palettes within acceptable contrast.\n'
