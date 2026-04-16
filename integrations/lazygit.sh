#!/usr/bin/env bash
# lazygit integration — rewrite config.yml from the palette's CLR_* values.
# Accent colors (active border, options text, cherry-pick fg) come from
# LAZYGIT_* exports in the theme file so new palettes don't touch this script.

_sss_lazygit_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/config.yml"
  [[ -f "$cfg" ]] || { _sss_debug "lazygit: skipped — $cfg not found"; return 0; }
  [[ -n "$CLR_TEXT" ]] || { _sss_debug "lazygit: skipped — CLR_TEXT unset"; return 0; }

  # Palette-provided accents; fall back to warm-orange defaults when a
  # palette doesn't ship the LAZYGIT_* exports (keeps older forks working).
  local lg_active_border="${LAZYGIT_ACTIVE_BORDER:-$CLR_PEACH}"
  local lg_options_text="${LAZYGIT_OPTIONS_TEXT:-$CLR_ROSEWATER}"
  local lg_cherry_fg="${LAZYGIT_CHERRY_FG:-$CLR_FLAMINGO}"

  _sss_backup "$cfg"

  cat > "$cfg" <<EOF
gui:
  theme:
    activeBorderColor:
      - "$lg_active_border"
      - bold
    inactiveBorderColor:
      - "$CLR_TEXT"
    optionsTextColor:
      - "$lg_options_text"
    selectedLineBgColor:
      - "$CLR_SURFACE0"
    selectedRangeBgColor:
      - "$CLR_SURFACE0"
    cherryPickedCommitBgColor:
      - "$CLR_SURFACE1"
    cherryPickedCommitFgColor:
      - "$lg_cherry_fg"
    unstagedChangesColor:
      - "$CLR_RED"
    defaultFgColor:
      - "$CLR_TEXT"
    searchingActiveBorderColor:
      - "$CLR_YELLOW"

git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
EOF
  _sss_debug "lazygit: rewrote $cfg"
}
