#!/usr/bin/env bash
# cmux integration — macOS only. Rewrites the palette-tracking fields in
# settings.json (selectionColor = warm accent, notificationBadgeColor =
# alert accent), then signals cmux to reload via an AppleScript keystroke.

_sss_cmux_sync() {
  [[ "$OSTYPE" == darwin* ]] || { _sss_debug "cmux: skipped — not macOS ($OSTYPE)"; return 0; }
  local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/cmux/settings.json"
  [[ -f "$cfg" ]] || { _sss_debug "cmux: skipped — $cfg not found"; return 0; }
  [[ -n "$CLR_PEACH" ]] || { _sss_debug "cmux: skipped — CLR_PEACH unset"; return 0; }
  _sss_backup "$cfg"
  # Match only the quoted value so any trailing comma / whitespace stays intact
  # (previous whole-line match silently stripped the comma and broke JSON when
  # selectionColor wasn't the last key in its block).
  _sss_sed_inplace "s|\"selectionColor\" : \"[^\"]*\"|\"selectionColor\" : \"$CLR_PEACH\"|" "$cfg"
  # Only rewrite notificationBadgeColor if it's already a hex string;
  # leave null / absent values alone so cmux's default still applies.
  if grep -qE '"notificationBadgeColor"[[:space:]]*:[[:space:]]*"#' "$cfg"; then
    _sss_sed_inplace "s|\"notificationBadgeColor\" : \"[^\"]*\"|\"notificationBadgeColor\" : \"$CLR_RED\"|" "$cfg"
  fi
  _sss_debug "cmux: rewrote selectionColor=$CLR_PEACH in $cfg"

  command -v osascript >/dev/null || { _sss_debug "cmux: osascript unavailable — skipping reload"; return 0; }
  osascript -e 'tell application "System Events" to tell process "cmux"
      set frontmost to true
      keystroke "," using {command down, shift down}
  end tell' 2>/dev/null
}
