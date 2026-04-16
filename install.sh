#!/usr/bin/env bash
# spaceship-sunset installer — idempotent.
#
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/williamtcastro/spaceship-sunset/main/install.sh)"
#
# Flags / env:
#   --theme=<name>                  non-interactive theme selection
#   --integrations=a,b,c            non-interactive integration selection (comma or space separated)
#   --no-select                     skip the interactive integration picker; enable all detected
#   SPACESHIP_SUNSET_THEME          same as --theme, via env
#   SPACESHIP_SUNSET_INTEGRATIONS   same as --integrations, via env
#   SPACESHIP_SUNSET_SOURCE         path to a local checkout; skips git clone (dev workflow)
#   SPACESHIP_SUNSET_HOME           install destination (default: $HOME/.spaceship-sunset)
set -euo pipefail

: "${SPACESHIP_SUNSET_HOME:=$HOME/.spaceship-sunset}"
: "${SPACESHIP_SUNSET_REPO:=https://github.com/williamtcastro/spaceship-sunset.git}"
: "${SPACESHIP_SUNSET_BRANCH:=main}"

default_theme="charcoal-vibrant-orange"
theme=""
integrations_override=""
no_select=0

for arg in "$@"; do
  case "$arg" in
    --theme=*) theme="${arg#--theme=}" ;;
    --integrations=*) integrations_override="${arg#--integrations=}" ;;
    --no-select) no_select=1 ;;
    --help|-h) sed -n '2,13p' "$0"; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

[[ -z "$theme" && -n "${SPACESHIP_SUNSET_THEME:-}" ]] && theme="$SPACESHIP_SUNSET_THEME"
[[ -z "$integrations_override" && -n "${SPACESHIP_SUNSET_INTEGRATIONS:-}" ]] && integrations_override="$SPACESHIP_SUNSET_INTEGRATIONS"

info() { printf '==> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

# Human-readable description for each integration — shown next to the
# name in the fzf picker and the fallback [Y/n] prompt so users know
# which file each toggle will touch. Keep descriptions short.
integration_desc() {
  case "$1" in
    bat)     echo "syntax highlighting  — ~/.config/bat/config" ;;
    btop)    echo "system monitor       — ~/.config/btop/btop.conf" ;;
    yazi)    echo "file manager         — ~/.config/yazi/theme.toml" ;;
    ghostty) echo "ghostty terminal     — ~/.config/ghostty/{config,themes/spaceship-sunset}" ;;
    wezterm) echo "wezterm terminal     — ~/.config/wezterm/wezterm.lua" ;;
    iterm2)  echo "iTerm2 terminal      — Library/Application Support/iTerm2/DynamicProfiles" ;;
    tmux)    echo "tmux status/panes    — ~/.config/tmux/spaceship-sunset.conf" ;;
    lazygit) echo "lazygit              — ~/.config/lazygit/config.yml" ;;
    nvim)    echo "neovim colorscheme   — ~/.config/nvim/active_theme" ;;
    delta)   echo "delta diff viewer    — ~/.gitconfig" ;;
    cmux)    echo "cmux                 — ~/.config/cmux/settings.json" ;;
    *)       echo "(no description)" ;;
  esac
}

check_dep() { command -v "$1" >/dev/null 2>&1 || warn "missing optional dependency: $1 ($2)"; }
check_dep zsh "the prompt targets zsh"
check_dep git "needed to fetch the repo"
check_dep fzf "used by set_theme's interactive picker"

# 1. Fetch repo (or reuse SPACESHIP_SUNSET_SOURCE).
if [[ -n "${SPACESHIP_SUNSET_SOURCE:-}" ]]; then
  info "using local source: $SPACESHIP_SUNSET_SOURCE"
  if [[ "$SPACESHIP_SUNSET_SOURCE" != "$SPACESHIP_SUNSET_HOME" ]]; then
    mkdir -p "$(dirname "$SPACESHIP_SUNSET_HOME")"
    rm -rf "$SPACESHIP_SUNSET_HOME"
    cp -R "$SPACESHIP_SUNSET_SOURCE" "$SPACESHIP_SUNSET_HOME"
    # Strip dev-only directories that shouldn't end up in a user's install.
    rm -rf "$SPACESHIP_SUNSET_HOME/.git" \
           "$SPACESHIP_SUNSET_HOME/.github" \
           "$SPACESHIP_SUNSET_HOME/.nwave"
  fi
elif [[ -d "$SPACESHIP_SUNSET_HOME/.git" ]]; then
  info "updating $SPACESHIP_SUNSET_HOME"
  git -C "$SPACESHIP_SUNSET_HOME" pull --ff-only --quiet || warn "git pull failed; keeping existing checkout"
else
  info "cloning $SPACESHIP_SUNSET_REPO to $SPACESHIP_SUNSET_HOME"
  git clone --depth 1 --branch "$SPACESHIP_SUNSET_BRANCH" "$SPACESHIP_SUNSET_REPO" "$SPACESHIP_SUNSET_HOME"
fi

# 2. Theme selection.
themes_dir="$SPACESHIP_SUNSET_HOME/themes"
available_themes=()
for f in "$themes_dir"/*.zsh; do
  [[ -f "$f" ]] || continue
  available_themes+=("$(basename "$f" .zsh)")
done

validate_theme() {
  local t="$1"
  for a in "${available_themes[@]}"; do
    [[ "$t" == "$a" ]] && return 0
  done
  return 1
}

if [[ -n "$theme" ]]; then
  if ! validate_theme "$theme"; then
    warn "unknown theme '$theme', falling back to $default_theme"
    theme="$default_theme"
  fi
elif [[ -t 0 && -t 1 ]]; then
  if command -v fzf >/dev/null 2>&1; then
    info "pick a theme (default: $default_theme):"
    theme=$(printf '%s\n' "${available_themes[@]}" | fzf --header "spaceship-sunset: select theme" --height=40% || true)
  else
    PS3="Select theme [1-${#available_themes[@]}]: "
    select choice in "${available_themes[@]}"; do [[ -n "$choice" ]] && theme="$choice" && break; done
  fi
  [[ -z "$theme" ]] && theme="$default_theme"
else
  theme="$default_theme"
fi

info "active theme: $theme"

# 3. Persist state.
mkdir -p "$SPACESHIP_SUNSET_HOME/state"
printf '%s\n' "$theme" > "$SPACESHIP_SUNSET_HOME/state/active_theme"

# 4. Auto-detect integrations based on existing configs.
xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
detected=()
[[ -f "$xdg/bat/config"          ]] && detected+=(bat)
[[ -f "$xdg/btop/btop.conf"      ]] && detected+=(btop)
[[ -f "$xdg/yazi/theme.toml"     ]] && detected+=(yazi)
[[ -f "$xdg/ghostty/config"      ]] && detected+=(ghostty)
[[ -f "$xdg/wezterm/wezterm.lua" ]] && detected+=(wezterm)
[[ -f "$xdg/lazygit/config.yml"  ]] && detected+=(lazygit)
[[ -f "$HOME/.tmux.conf" || -f "$xdg/tmux/tmux.conf" ]] && detected+=(tmux)
[[ -d "$xdg/nvim"                ]] && detected+=(nvim)
[[ -f "$HOME/.gitconfig"         ]] && detected+=(delta)
[[ "$OSTYPE" == darwin* && -f "$xdg/cmux/settings.json" ]] && detected+=(cmux)
[[ "$OSTYPE" == darwin* && ( -d "/Applications/iTerm.app" || -d "$HOME/Applications/iTerm.app" || -d "$HOME/Library/Application Support/iTerm2" ) ]] && detected+=(iterm2)

# 4a. Narrow detected → selected. Non-interactive overrides win; otherwise
# offer a picker so users can opt out of individual tools before first sync.
known=()
for _f in "$SPACESHIP_SUNSET_HOME/integrations"/*.sh; do
  [[ -f "$_f" ]] && known+=("$(basename "$_f" .sh)")
done

selected=()
if [[ -n "$integrations_override" ]]; then
  # Accept comma or space separated. Validate against shipped integrations
  # (not just auto-detected) so users can opt in to tools whose configs
  # they'll create later — e.g. iTerm2 before first launch.
  IFS=', ' read -r -a _requested <<<"$integrations_override"
  for r in "${_requested[@]}"; do
    [[ -z "$r" ]] && continue
    _valid=0
    for k in "${known[@]}"; do [[ "$r" == "$k" ]] && _valid=1 && break; done
    if (( _valid == 1 )); then
      selected+=("$r")
    else
      warn "unknown integration '$r' (skipping)"
    fi
  done
elif (( no_select == 1 )) || (( ${#detected[@]} == 0 )) || [[ ! -t 0 || ! -t 1 ]]; then
  selected=("${detected[@]}")
elif command -v fzf >/dev/null 2>&1; then
  info "pick integrations (TAB multi-select, ENTER confirm, ESC = enable all)"
  # Render rows as "name    description" so users see which config each
  # toggle touches. fzf's --with-nth restricts the visible columns;
  # after selection we cut column 1 back out to match the INTEGRATIONS list.
  _chosen=$({
    for t in "${detected[@]}"; do printf '%s\t%s\n' "$t" "$(integration_desc "$t")"; done
  } | fzf --multi --header "spaceship-sunset: select integrations (TAB = toggle, ENTER = confirm)" --height=40% \
          --delimiter=$'\t' --with-nth='1,2' \
          --bind 'ctrl-a:select-all,ctrl-d:deselect-all' || true)
  if [[ -n "$_chosen" ]]; then
    while IFS=$'\t' read -r _name _rest; do
      [[ -n "$_name" ]] && selected+=("$_name")
    done <<<"$_chosen"
  else
    selected=("${detected[@]}")
  fi
else
  info "detected integrations — reply [y/N] for each (default: yes)"
  for t in "${detected[@]}"; do
    _ans=""
    read -r -p "  enable $t ($(integration_desc "$t")) [Y/n] " _ans </dev/tty || _ans=""
    case "$_ans" in n|N|no|NO) ;; *) selected+=("$t") ;; esac
  done
fi

if [[ ! -f "$SPACESHIP_SUNSET_HOME/config" ]]; then
  {
    printf '# spaceship-sunset opt-in integrations (edit to remove a tool).\n'
    printf 'INTEGRATIONS=(%s)\n' "${selected[*]:-}"
  } > "$SPACESHIP_SUNSET_HOME/config"
  info "enabled integrations: ${selected[*]:-none}"
else
  info "keeping existing integrations config at $SPACESHIP_SUNSET_HOME/config"
fi

# 5. One-shot sync (writes *.spaceship-sunset.bak snapshots on first touch).
info "running first sync..."
zsh -c "source '$SPACESHIP_SUNSET_HOME/lib/init.zsh' && sync_theme '$theme'" || warn "initial sync had errors"

# 6. Append managed block to .zshrc (skip if markers already present).
zshrc="$HOME/.zshrc"
begin_marker='# >>> spaceship-sunset >>>'
end_marker='# <<< spaceship-sunset <<<'
touch "$zshrc"
# Snapshot .zshrc before first modification — restored by uninstall.sh if the
# surgical managed-block removal ever fails. Only written on first install.
if [[ ! -f "$zshrc.spaceship-sunset.bak" ]]; then
  cp "$zshrc" "$zshrc.spaceship-sunset.bak"
  info "snapshotted $zshrc -> $zshrc.spaceship-sunset.bak"
fi
if grep -qF "$begin_marker" "$zshrc"; then
  info ".zshrc managed block already present; leaving alone"
else
  {
    printf '\n%s\n' "$begin_marker"
    printf '# Managed by spaceship-sunset. Changes here may be overwritten.\n'
    printf 'export SPACESHIP_SUNSET_HOME="%s"\n' "$SPACESHIP_SUNSET_HOME"
    # shellcheck disable=SC2016  # single-quoted intentionally: emit literal $VAR for the shell that later sources .zshrc.
    printf '[ -f "$SPACESHIP_SUNSET_HOME/lib/init.zsh" ] && source "$SPACESHIP_SUNSET_HOME/lib/init.zsh"\n'
    printf '%s\n' "$end_marker"
  } >> "$zshrc"
  info "appended managed block to $zshrc"
fi

cat <<EOF

spaceship-sunset is installed.

Next steps:
  1. Install Spaceship itself (if not already) — e.g. via zinit:
       zinit light spaceship-prompt/spaceship-prompt
     or manually clone to a plugin dir.
  2. Open a new shell (or 'exec zsh') to load the prompt.
  3. Switch themes anytime with: set_theme

EOF
