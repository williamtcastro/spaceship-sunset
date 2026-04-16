#!/usr/bin/env bash
# cmux integration — macOS only. Rewrites selectionColor in settings.json and
# signals cmux to reload via an AppleScript keystroke.

_sss_cmux_sync() {
  [[ "$OSTYPE" == darwin* ]] || return 0
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/cmux/settings.json"
  [[ -f "$cfg" ]] || return 0
  [[ -n "$CLR_PEACH" ]] || return 0
  _sss_backup "$cfg"
  _sss_sed_inplace "s|\"selectionColor\" : .*|\"selectionColor\" : \"$CLR_PEACH\"|" "$cfg"

  command -v osascript >/dev/null || return 0
  osascript -e 'tell application "System Events" to tell process "cmux"
      set frontmost to true
      keystroke "," using {command down, shift down}
  end tell' 2>/dev/null
}
