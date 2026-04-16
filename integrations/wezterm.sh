#!/usr/bin/env bash
# wezterm integration — rewrite config.color_scheme from $WEZTERM_COLOR_SCHEME
# (exported by the palette). Adding a new palette no longer requires editing
# this file: just set WEZTERM_COLOR_SCHEME in the theme's .zsh file.

_sss_wezterm_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm.lua"
  [[ -f "$cfg" ]] || { _sss_debug "wezterm: skipped — $cfg not found"; return 0; }
  [[ -n "$WEZTERM_COLOR_SCHEME" ]] || { _sss_debug "wezterm: skipped — WEZTERM_COLOR_SCHEME unset"; return 0; }

  _sss_backup "$cfg"
  _sss_sed_inplace "s|config.color_scheme = '.*'|config.color_scheme = '$WEZTERM_COLOR_SCHEME'|" "$cfg"
  _sss_debug "wezterm: rewrote config.color_scheme = '$WEZTERM_COLOR_SCHEME' in $cfg"
}
