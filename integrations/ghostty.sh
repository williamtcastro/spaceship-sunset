#!/usr/bin/env bash
# ghostty integration — generate a palette-derived theme file at
# ~/.config/ghostty/themes/spaceship-sunset, then pin the dark half of the
# user's config to it. Self-contained: no reliance on ghostty shipping (or
# the user manually providing) a theme whose name matches the active palette.
# Light half stays pinned to Catppuccin Latte.

_sss_ghostty_sync() {
  local xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
  local cfg="$xdg/ghostty/config"
  [[ -f "$cfg" ]] || { _sss_debug "ghostty: skipped — $cfg not found"; return 0; }
  [[ -n "$CLR_BASE" ]] || { _sss_debug "ghostty: skipped — CLR_BASE unset"; return 0; }

  local theme_dir="$xdg/ghostty/themes"
  mkdir -p "$theme_dir"
  local theme_file="$theme_dir/spaceship-sunset"

  cat > "$theme_file" <<EOF
background = $CLR_BASE
foreground = $CLR_TEXT
selection-background = $CLR_SURFACE2
selection-foreground = $CLR_TEXT
cursor-color = $CLR_ROSEWATER

palette = 0=$CLR_SURFACE1
palette = 1=$CLR_RED
palette = 2=$CLR_GREEN
palette = 3=$CLR_YELLOW
palette = 4=$CLR_BLUE
palette = 5=$CLR_PINK
palette = 6=$CLR_TEAL
palette = 7=$CLR_SUBTEXT1
palette = 8=$CLR_SURFACE2
palette = 9=$CLR_RED
palette = 10=$CLR_GREEN
palette = 11=$CLR_YELLOW
palette = 12=$CLR_BLUE
palette = 13=$CLR_MAUVE
palette = 14=$CLR_SAPPHIRE
palette = 15=$CLR_TEXT
EOF

  _sss_backup "$cfg"
  _sss_sed_inplace "s|theme = dark:.*,light:Catppuccin Latte|theme = dark:spaceship-sunset,light:Catppuccin Latte|" "$cfg"
  _sss_debug "ghostty: wrote $theme_file and pinned theme = dark:spaceship-sunset"
}
