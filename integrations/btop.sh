#!/usr/bin/env bash
# btop integration — rewrite color_theme in btop.conf.

_sss_btop_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/btop/btop.conf"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$BTOP_THEME" ]] || return 0
  _sss_backup "$cfg"
  _sss_sed_inplace "s|color_theme = \".*\"|color_theme = \"$BTOP_THEME\"|" "$cfg"
}
