#!/usr/bin/env bash
# lazygit integration — rewrite config.yml from the palette's CLR_* values.

_sss_lazygit_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/lazygit/config.yml"
  local theme="${1:-$ACTIVE_THEME}"
  [[ -f "$cfg" ]] || return 0

  local lg_active_border="$CLR_TEAL"
  local lg_options_text="$CLR_BLUE"
  local lg_cherry_fg="$CLR_TEAL"
  if [[ "$theme" != catppuccin-* ]]; then
    lg_active_border="$CLR_PEACH"
    lg_options_text="$CLR_ROSEWATER"
    lg_cherry_fg="$CLR_FLAMINGO"
  fi

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
}
