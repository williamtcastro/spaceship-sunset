#!/usr/bin/env bash
# wezterm integration — rewrite config.color_scheme. Maps catppuccin-<variant> to
# "Catppuccin <Variant>"; other palettes pass through as-is.

_sss_wezterm_sync() {
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm.lua"
  local theme="${1:-$ACTIVE_THEME}"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$theme" ]] || return 0

  local wez_theme="$theme"
  case "$theme" in
    catppuccin-frappe)    wez_theme="Catppuccin Frappe" ;;
    catppuccin-macchiato) wez_theme="Catppuccin Macchiato" ;;
    catppuccin-mocha)     wez_theme="Catppuccin Mocha" ;;
  esac

  _sss_backup "$cfg"
  _sss_sed_inplace "s|config.color_scheme = '.*'|config.color_scheme = '$wez_theme'|" "$cfg"
}
