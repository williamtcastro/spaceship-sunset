#!/usr/bin/env bash
# delta integration — set delta.syntax-theme in the user's ~/.gitconfig to mirror BAT_THEME.

_sss_delta_sync() {
  local cfg="$HOME/.gitconfig"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$BAT_THEME" ]] || return 0
  command -v git >/dev/null || return 0
  _sss_backup "$cfg"
  git config --file "$cfg" delta.syntax-theme "$BAT_THEME"
}
