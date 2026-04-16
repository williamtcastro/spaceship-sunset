#!/usr/bin/env bash
# bat integration — rewrite the --theme line in the user's bat config.

_sss_bat_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/bat/config"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$BAT_THEME" ]] || return 0
  _sss_backup "$cfg"
  _sss_sed_inplace "s|--theme=\".*\"|--theme=\"$BAT_THEME\"|" "$cfg"
}
