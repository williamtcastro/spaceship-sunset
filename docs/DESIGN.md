# Design: Sunset Orange

Warm-orange Spaceship prompt with centralized color variables and palette-coordinated tool integrations.

## Visual preview

` ~/dotfiles` · ` main` · ` 1.5s` · `󰚩 c` · ` 16:15` · `williamtcastro@ella`
`> `

## Core philosophy

- **Separation:** centered dots (` · `) as uniform suffixes.
- **Hierarchy:** warm gradient using oranges and golds for high visibility without clash.
- **Centralization:** palettes export `CLR_*` / `SPACESHIP_CLR_*` so the entire terminal stack stays in lockstep.

## Prompt layout

Defined in `lib/spaceship.zsh`:

```zsh
SPACESHIP_PROMPT_ORDER=(
  dir git exec_time claude gemini time user host
  line_sep jobs exit_code char
)
```

## Spaceship colors (palette-driven)

Every palette exports:

- `SPACESHIP_CLR_DIR`    → warm orange (location)
- `SPACESHIP_CLR_GIT`    → vibrant orange (status)
- `SPACESHIP_CLR_EXEC`   → golden orange (performance)
- `SPACESHIP_CLR_AI`     → peach (legacy reference)
- `SPACESHIP_CLR_CLAUDE` → status tint for Claude section
- `SPACESHIP_CLR_GEMINI` → status tint for Gemini section
- `SPACESHIP_CLR_TIME`   → deep gold (time)
- `SPACESHIP_CLR_USER`   → identity
- `SPACESHIP_CLR_HOST`   → identity contrast

## Custom sections

`lib/sections/claude.zsh` — `spaceship_claude` renders `󱜙 S4.7 [M] 󰄴`:
- Claude Code model letter + version
- Effort level in brackets
- Circled status icon reflecting api.anthropic.com health
- Gracefully returns if `claude` binary isn't on PATH.

`lib/sections/gemini.zsh` — `spaceship_gemini` renders ` F2.0 󰄴`:
- Gemini model letter + version
- Status icon reflecting generativelanguage.googleapis.com health
- Gracefully returns if `gemini` binary isn't on PATH.

Both sections:
- Cache status checks (5-minute TTL) and model reads (per-file-mtime).
- Read `CLAUDE_CODE_EFFORT_LEVEL` / `GEMINI_CODE_MODEL` as env fallbacks.
- Do nothing if their binary is absent, so the prompt gracefully degrades.

## tmux integration limitation (v1)

tmux's catppuccin plugin uses `@catppuccin_flavour`, which has no equivalent
for nord or charcoal palettes. `integrations/tmux.sh` is a no-op in v1 — the
status line stays on whatever flavor you pinned manually. Contributions to
generalize this (e.g. a mapping layer, or switching to a palette-agnostic
tmux theme) are welcome.

## State and persistence

- `~/.spaceship-sunset/state/active_theme` — current theme name. Read by
  `init.zsh`, written by `sync_theme`.
- `~/.spaceship-sunset/config` — opt-in integrations list. Written on first
  install from auto-detected configs; edit to remove a tool.
- `${XDG_CACHE_HOME:-~/.cache}/spaceship-sunset/synced_theme` — last-synced
  theme marker. Makes shell startup a no-op when the theme hasn't changed.
