#!/usr/bin/env bash
# bat integration — rewrite the --theme line in the user's bat config.

_sss_bat_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/bat/config"
  [[ -f "$cfg" ]] || { _sss_debug "bat: skipped — $cfg not found"; return 0; }
  [[ -n "$BAT_THEME" ]] || { _sss_debug "bat: skipped — BAT_THEME unset"; return 0; }
  _sss_backup "$cfg"
  _sss_sed_inplace "s|--theme=\".*\"|--theme=\"$BAT_THEME\"|" "$cfg"
  _sss_debug "bat: rewrote --theme=\"$BAT_THEME\" in $cfg"
}
