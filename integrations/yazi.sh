#!/usr/bin/env bash
# yazi integration — rewrite flavor in theme.toml.

_sss_yazi_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/yazi/theme.toml"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$YAZI_FLAVOR" ]] || return 0
  _sss_backup "$cfg"
  _sss_sed_inplace "s|use = \".*\"|use = \"$YAZI_FLAVOR\"|" "$cfg"
}
