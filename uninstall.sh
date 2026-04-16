#!/usr/bin/env bash
# spaceship-sunset uninstaller — removes the managed block from .zshrc,
# restores every *.spaceship-sunset.bak snapshot, and deletes SPACESHIP_SUNSET_HOME.
set -euo pipefail

: "${SPACESHIP_SUNSET_HOME:=$HOME/.spaceship-sunset}"

info() { printf '==> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

# 1. Strip managed block from .zshrc. Prefer surgical sed over snapshot restore
# so user edits made after install are preserved. Snapshot is the fallback if
# markers went missing somehow (hand-edited).
zshrc="$HOME/.zshrc"
zshrc_bak="$zshrc.spaceship-sunset.bak"
begin_marker='# >>> spaceship-sunset >>>'
end_marker='# <<< spaceship-sunset <<<'
if [[ -f "$zshrc" ]] && grep -qF "$begin_marker" "$zshrc"; then
  info "removing managed block from $zshrc"
  if sed --version >/dev/null 2>&1; then
    sed -i -e "/$begin_marker/,/$end_marker/d" "$zshrc"
  else
    sed -i '' -e "/$begin_marker/,/$end_marker/d" "$zshrc"
  fi
elif [[ -f "$zshrc_bak" ]]; then
  warn "markers missing in $zshrc; restoring from snapshot $zshrc_bak"
  cp "$zshrc_bak" "$zshrc"
fi
# Snapshot has served its purpose — remove it so the .bak restoration loop
# below doesn't clobber the surgically-edited .zshrc.
[[ -f "$zshrc_bak" ]] && rm -f "$zshrc_bak"

# 2. Restore every .spaceship-sunset.bak snapshot under $XDG_CONFIG_HOME. These
# were written by integrations on first touch of each tool's config.
info "restoring .spaceship-sunset.bak snapshots..."
xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
if [[ -d "$xdg" ]]; then
  while IFS= read -r -d '' bak; do
    orig="${bak%.spaceship-sunset.bak}"
    info "  $orig"
    mv -f "$bak" "$orig"
  done < <(find "$xdg" -type f -name '*.spaceship-sunset.bak' -print0)
fi

# Handle the one $HOME-level snapshot we write: ~/.gitconfig.spaceship-sunset.bak
# (the delta integration edits $HOME/.gitconfig, not an XDG path).
if [[ -f "$HOME/.gitconfig.spaceship-sunset.bak" ]]; then
  info "  $HOME/.gitconfig"
  mv -f "$HOME/.gitconfig.spaceship-sunset.bak" "$HOME/.gitconfig"
fi

# iTerm2 dynamic profile lives outside $XDG and is a file we create (not edit),
# so there's no snapshot to restore — just drop the file we wrote.
iterm2_profile="$HOME/Library/Application Support/iTerm2/DynamicProfiles/spaceship-sunset.json"
if [[ -f "$iterm2_profile" ]]; then
  info "  removing iTerm2 dynamic profile $iterm2_profile"
  rm -f "$iterm2_profile"
fi

# Ghostty theme file we generate. Same reasoning as iTerm2: it's a file we
# create (no .bak snapshot), so delete it explicitly on uninstall.
ghostty_theme="$xdg/ghostty/themes/spaceship-sunset"
if [[ -f "$ghostty_theme" ]]; then
  info "  removing ghostty theme $ghostty_theme"
  rm -f "$ghostty_theme"
fi

# tmux theme file we generate (users source it from their tmux config).
tmux_theme="$xdg/tmux/spaceship-sunset.conf"
if [[ -f "$tmux_theme" ]]; then
  info "  removing tmux theme $tmux_theme"
  rm -f "$tmux_theme"
fi

# 3. Remove $SPACESHIP_SUNSET_HOME (installed repo + state + config).
if [[ -d "$SPACESHIP_SUNSET_HOME" ]]; then
  info "removing $SPACESHIP_SUNSET_HOME"
  rm -rf "$SPACESHIP_SUNSET_HOME"
fi

# 4. Remove cache dir.
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/spaceship-sunset"
if [[ -d "$cache_dir" ]]; then
  info "removing $cache_dir"
  rm -rf "$cache_dir"
fi

info "uninstall complete. Open a new shell to drop the spaceship-sunset environment."
