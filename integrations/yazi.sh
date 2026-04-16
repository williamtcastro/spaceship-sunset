#!/usr/bin/env bash
# yazi integration — rewrite flavor in theme.toml.

_sss_yazi_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/yazi/theme.toml"
  [[ -f "$cfg" ]] || { _sss_debug "yazi: skipped — $cfg not found"; return 0; }
  [[ -n "$YAZI_FLAVOR" ]] || { _sss_debug "yazi: skipped — YAZI_FLAVOR unset"; return 0; }
  _sss_backup "$cfg"
  _sss_sed_inplace "s|use = \".*\"|use = \"$YAZI_FLAVOR\"|" "$cfg"
  _sss_debug "yazi: rewrote use=\"$YAZI_FLAVOR\" in $cfg"
}
