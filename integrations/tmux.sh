#!/usr/bin/env bash
# tmux integration — generate a palette-derived theme file that users source
# from their tmux config. Regenerated on every sync so palette swaps flow
# through without any tmux-plugin dependency.

_sss_tmux_sync() {
  [[ -n "$CLR_BASE" ]] || { _sss_debug "tmux: skipped — CLR_BASE unset"; return 0; }

  local xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
  local tmux_dir="$xdg/tmux"
  mkdir -p "$tmux_dir"
  local out="$tmux_dir/spaceship-sunset.conf"

  cat > "$out" <<EOF
# spaceship-sunset — palette-derived tmux theme. Regenerated on sync.
# Source this from your tmux config: source-file ~/.config/tmux/spaceship-sunset.conf

set -g status-style                   "bg=$CLR_BASE,fg=$CLR_TEXT"
set -g status-left                    "#[fg=$CLR_ROSEWATER,bg=$CLR_SURFACE0,bold] #S #[bg=$CLR_BASE,fg=$CLR_SURFACE0]"
set -g status-right                   "#[fg=$CLR_PEACH]%H:%M #[fg=$CLR_TEXT,bg=$CLR_SURFACE0] #(whoami) "

set -w -g window-status-style         "fg=$CLR_TEXT,bg=$CLR_BASE"
set -w -g window-status-current-style "fg=$CLR_ROSEWATER,bg=$CLR_SURFACE0,bold"
set -w -g window-status-activity-style "fg=$CLR_YELLOW,bg=$CLR_BASE"

set -g pane-border-style              "fg=$CLR_SURFACE1"
set -g pane-active-border-style       "fg=$CLR_PEACH"

set -g message-style                  "bg=$CLR_SURFACE0,fg=$CLR_TEXT"
set -g message-command-style          "bg=$CLR_SURFACE0,fg=$CLR_ROSEWATER"

set -g mode-style                     "bg=$CLR_SURFACE1,fg=$CLR_ROSEWATER"
EOF
  _sss_debug "tmux: wrote $out"
}
