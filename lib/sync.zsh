#!/usr/bin/env zsh
# sync_theme / set_theme — rewrite opted-in tool configs to match the active palette.
# Portable across BSD (macOS) and GNU (Linux) sed.

: ${SPACESHIP_SUNSET_HOME:="$HOME/.spaceship-sunset"}
: ${SPACESHIP_SUNSET_ROOT:="${0:A:h:h}"}

# _sss_sed_inplace <pattern> <file> — in-place edit that works on BSD and GNU sed.
_sss_sed_inplace() {
  local pattern="$1" file="$2"
  if sed --version >/dev/null 2>&1; then
    sed -i -e "$pattern" "$file"       # GNU
  else
    sed -i '' -e "$pattern" "$file"    # BSD / macOS
  fi
}

# _sss_backup <file> — snapshot to <file>.spaceship-sunset.bak on first touch.
_sss_backup() {
  local file="$1"
  [[ -f "$file" && ! -f "$file.spaceship-sunset.bak" ]] && cp "$file" "$file.spaceship-sunset.bak"
}

# _sss_load_config — load opt-in INTEGRATIONS list from ~/.spaceship-sunset/config,
# falling back to every integration whose detection probe passes.
_sss_load_config() {
  if [[ -f "$SPACESHIP_SUNSET_HOME/config" ]]; then
    source "$SPACESHIP_SUNSET_HOME/config"
  fi
  if (( ${#INTEGRATIONS[@]} == 0 )); then
    INTEGRATIONS=(bat btop yazi ghostty wezterm tmux lazygit nvim delta cmux)
  fi
}

sync_theme() {
  local theme="${1:-$ACTIVE_THEME}"

  if [[ ! -f "$SPACESHIP_SUNSET_ROOT/themes/$theme.zsh" ]]; then
    print -u2 -- "Error: theme '$theme' not found in $SPACESHIP_SUNSET_ROOT/themes/"
    return 1
  fi

  source "$SPACESHIP_SUNSET_ROOT/themes/$theme.zsh"
  export ACTIVE_THEME="$theme"
  mkdir -p "$SPACESHIP_SUNSET_HOME/state"
  print -r -- "$theme" > "$SPACESHIP_SUNSET_HOME/state/active_theme"

  print -- "Syncing terminal theme to: $theme"

  _sss_load_config

  local tool
  for tool in "${INTEGRATIONS[@]}"; do
    local integration="$SPACESHIP_SUNSET_ROOT/integrations/${tool}.sh"
    if [[ -f "$integration" ]]; then
      source "$integration"
      if typeset -f "_sss_${tool}_sync" >/dev/null; then
        "_sss_${tool}_sync" "$theme"
      fi
    fi
  done

  # Persist sync cache so init.zsh's auto-sync skips on next shell startup.
  local sync_cache="${XDG_CACHE_HOME:-$HOME/.cache}/spaceship-sunset/synced_theme"
  mkdir -p "${sync_cache:h}"
  print -r -- "$theme" > "$sync_cache"

  print -- "Theme synced. Restart your shell to apply prompt/palette changes."
}

set_theme() {
  local themes_dir="$SPACESHIP_SUNSET_ROOT/themes"
  local selected

  # Direct invocation: `set_theme <name>` skips the picker.
  if [[ $# -gt 0 ]]; then
    if [[ -f "$themes_dir/$1.zsh" ]]; then
      sync_theme "$1"
      return $?
    else
      print -u2 -- "set_theme: unknown theme '$1'"
      print -u2 -- 'Available:'
      command ls "$themes_dir" | grep '\.zsh$' | sed 's/\.zsh$/  /' >&2
      return 1
    fi
  fi

  if command -v fzf >/dev/null; then
    selected=$(command ls "$themes_dir" | grep '\.zsh$' | sed 's/\.zsh$//' | \
      fzf --header 'Select spaceship-sunset theme' \
          --preview "test -r '$themes_dir/{}.zsh' && (command -v bat >/dev/null && bat --color=always --style=numbers '$themes_dir/{}.zsh' || cat '$themes_dir/{}.zsh')")
  else
    local -a themes
    themes=($(command ls "$themes_dir" | grep '\.zsh$' | sed 's/\.zsh$//'))
    print -- 'Select a theme:'
    select selected in $themes; do [[ -n "$selected" ]] && break; done
  fi

  [[ -n "$selected" ]] && sync_theme "$selected"
}
