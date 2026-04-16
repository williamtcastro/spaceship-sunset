#!/usr/bin/env bash
# tmux integration — NO-OP in v1.
#
# tmux's catppuccin plugin uses @catppuccin_flavour, which has no equivalent
# variable for nord / charcoal palettes. Rather than lie about cross-palette
# coverage, v1 documents the limitation in docs/DESIGN.md and leaves tmux
# untouched. Contributions welcome.

_sss_tmux_sync() {
  return 0
}
