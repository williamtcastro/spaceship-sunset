#!/usr/bin/env bash
# neovim integration — write active theme to ~/.config/nvim/active_theme.
# Users can wire this into their nvim config (watch the file for live reload,
# or read it on startup and pass to colorscheme).

_sss_nvim_sync() {
  local theme="${1:-$ACTIVE_THEME}"
  local nvim_cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  [[ -d "$nvim_cfg_dir" ]] || { _sss_debug "nvim: skipped — $nvim_cfg_dir not found"; return 0; }
  [[ -n "$theme" ]] || { _sss_debug "nvim: skipped — theme unset"; return 0; }
  local target="$nvim_cfg_dir/active_theme"
  # Snapshot the previous file (if any) so uninstall can restore it.
  [[ -f "$target" && ! -f "$target.spaceship-sunset.bak" ]] && cp "$target" "$target.spaceship-sunset.bak"
  printf '%s\n' "$theme" > "$target"
  _sss_debug "nvim: wrote active_theme=$theme to $target"
}
