#!/usr/bin/env bash
# delta integration — set delta.syntax-theme in the user's ~/.gitconfig to mirror BAT_THEME.

_sss_delta_sync() {
  local cfg="$HOME/.gitconfig"
  [[ -f "$cfg" ]] || { _sss_debug "delta: skipped — $cfg not found"; return 0; }
  [[ -n "$BAT_THEME" ]] || { _sss_debug "delta: skipped — BAT_THEME unset"; return 0; }
  command -v git >/dev/null || { _sss_debug "delta: skipped — git not on PATH"; return 0; }
  _sss_backup "$cfg"
  git config --file "$cfg" delta.syntax-theme "$BAT_THEME"
  _sss_debug "delta: set delta.syntax-theme=$BAT_THEME in $cfg"
}
