#!/usr/bin/env bash
# ghostty integration — rewrite dark theme in config; light pinned to Catppuccin Latte.

_sss_ghostty_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
  local theme="${1:-$ACTIVE_THEME}"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$theme" ]] || return 0
  _sss_backup "$cfg"
  _sss_sed_inplace "s|theme = dark:.*,light:Catppuccin Latte|theme = dark:$theme,light:Catppuccin Latte|" "$cfg"
}
