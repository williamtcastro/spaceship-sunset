# Creating themes

A palette is a single zsh file under `themes/<name>.zsh` that exports the
variables consumed by the prompt sections and tool integrations.

## Required contract

Every palette MUST export:

### Identity
- `THEME_NAME`     — string, equals the filename without `.zsh`.

### `CLR_*` color wheel (hex `#RRGGBB`)

Main palette:
```
CLR_ROSEWATER CLR_FLAMINGO CLR_PINK CLR_MAUVE
CLR_RED CLR_MAROON CLR_PEACH CLR_YELLOW
CLR_GREEN CLR_TEAL CLR_SKY CLR_SAPPHIRE
CLR_BLUE CLR_LAVENDER
```

Surfaces (light → dark):
```
CLR_TEXT CLR_SUBTEXT1 CLR_SUBTEXT0
CLR_OVERLAY2 CLR_OVERLAY1 CLR_OVERLAY0
CLR_SURFACE2 CLR_SURFACE1 CLR_SURFACE0
CLR_BASE CLR_MANTLE CLR_CRUST
```

These names come from the Catppuccin taxonomy. Nord and charcoal variants
map their colors into the same slots.

### Spaceship section tints
```
SPACESHIP_CLR_DIR     SPACESHIP_CLR_GIT     SPACESHIP_CLR_EXEC
SPACESHIP_CLR_AI      SPACESHIP_CLR_CLAUDE  SPACESHIP_CLR_GEMINI
SPACESHIP_CLR_TIME    SPACESHIP_CLR_USER    SPACESHIP_CLR_HOST
```

Plus the remapped section variables themselves:
```
SPACESHIP_DIR_COLOR   SPACESHIP_GIT_COLOR   SPACESHIP_EXEC_TIME_COLOR
SPACESHIP_TIME_COLOR  SPACESHIP_USER_COLOR  SPACESHIP_HOST_COLOR
```

### Tool theme names
- `BAT_THEME`        — one of `bat --list-themes`. E.g. `"Nord"`, `"ansi"`.
- `BTOP_THEME`       — a filename under btop's themes dir (no extension).
- `YAZI_FLAVOR`      — a yazi flavor name (e.g. `"nord"`, `"dracula"`).
- `FZF_DEFAULT_OPTS` — a `--color=` spec that references the `CLR_*` values.

## Template

```zsh
# My Custom Theme
export THEME_NAME="my-custom"
export YAZI_FLAVOR="<yazi-flavor-name>"

export CLR_ROSEWATER="#RRGGBB"
# ... (full CLR_* set)

export FZF_DEFAULT_OPTS=" \
--color=bg+:$CLR_SURFACE0,bg:$CLR_BASE,spinner:$CLR_ROSEWATER,hl:$CLR_RED \
--color=fg:$CLR_TEXT,header:$CLR_RED,info:$CLR_MAUVE,pointer:$CLR_ROSEWATER \
--color=marker:$CLR_ROSEWATER,fg+:$CLR_TEXT,prompt:$CLR_MAUVE,hl+:$CLR_RED"

export BAT_THEME="..."
export BTOP_THEME="..."

export SPACESHIP_CLR_DIR="$CLR_FLAMINGO"
# ... (full SPACESHIP_CLR_* set)

export SPACESHIP_DIR_COLOR="$SPACESHIP_CLR_DIR"
# ... (remap)
```

## Testing a new palette

```bash
cp ~/spaceship-sunset/themes/nord-vibrant-orange.zsh \
   ~/spaceship-sunset/themes/my-custom.zsh
# edit
set_theme    # pick "my-custom" in the fzf picker
```

If `BAT_THEME` or `BTOP_THEME` doesn't exist on your system, the integration
will rewrite the config but bat/btop will fall back to their default.
