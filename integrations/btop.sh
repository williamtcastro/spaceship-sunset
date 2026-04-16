#!/usr/bin/env bash
# btop integration — rewrite color_theme in btop.conf.

_sss_btop_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/btop/btop.conf"
  [[ -f "$cfg" ]] || { _sss_debug "btop: skipped — $cfg not found"; return 0; }
  [[ -n "$BTOP_THEME" ]] || { _sss_debug "btop: skipped — BTOP_THEME unset"; return 0; }
  _sss_backup "$cfg"
  _sss_sed_inplace "s|color_theme = \".*\"|color_theme = \"$BTOP_THEME\"|" "$cfg"
  _sss_debug "btop: rewrote color_theme=\"$BTOP_THEME\" in $cfg"
}
