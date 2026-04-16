#!/usr/bin/env zsh
# spaceship-sunset entrypoint — users source this from their .zshrc.
# Reads the active theme from state, sources the palette + prompt config + sections,
# and exposes sync_theme / set_theme commands.

: ${SPACESHIP_SUNSET_HOME:="$HOME/.spaceship-sunset"}
: ${SPACESHIP_SUNSET_ROOT:="${0:A:h:h}"}

_sss_state_dir="$SPACESHIP_SUNSET_HOME/state"
_sss_active_theme_file="$_sss_state_dir/active_theme"
_sss_config_file="$SPACESHIP_SUNSET_HOME/config"

mkdir -p "$_sss_state_dir"

# Default theme if state file missing.
if [[ -f "$_sss_active_theme_file" ]]; then
  export ACTIVE_THEME="$(<"$_sss_active_theme_file")"
else
  export ACTIVE_THEME="nord-vibrant-orange"
  print -r -- "$ACTIVE_THEME" > "$_sss_active_theme_file"
fi

# Load palette — sets CLR_*, SPACESHIP_CLR_*, BAT_THEME, BTOP_THEME, YAZI_FLAVOR, FZF_DEFAULT_OPTS.
if [[ -f "$SPACESHIP_SUNSET_ROOT/themes/$ACTIVE_THEME.zsh" ]]; then
  source "$SPACESHIP_SUNSET_ROOT/themes/$ACTIVE_THEME.zsh"
else
  print -u2 -- "spaceship-sunset: theme '$ACTIVE_THEME' not found in $SPACESHIP_SUNSET_ROOT/themes/"
fi

# Prompt config (PROMPT_ORDER + SPACESHIP_* section settings).
source "$SPACESHIP_SUNSET_ROOT/lib/spaceship.zsh"

# Custom prompt sections (Claude, Gemini). Each gracefully degrades if deps missing.
for _sss_section in "$SPACESHIP_SUNSET_ROOT"/lib/sections/*.zsh; do
  source "$_sss_section"
done
unset _sss_section

# sync_theme / set_theme commands + portable sed helper.
source "$SPACESHIP_SUNSET_ROOT/lib/sync.zsh"

# Auto-sync on interactive shell startup if theme changed since last sync.
if [[ -o interactive ]]; then
  _sss_sync_cache="${XDG_CACHE_HOME:-$HOME/.cache}/spaceship-sunset/synced_theme"
  if [[ "$(<"$_sss_sync_cache" 2>/dev/null)" != "$ACTIVE_THEME" ]]; then
    mkdir -p "${_sss_sync_cache:h}"
    sync_theme "$ACTIVE_THEME" &>/dev/null
  fi
  unset _sss_sync_cache
fi

unset _sss_state_dir _sss_active_theme_file _sss_config_file
