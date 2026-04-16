# Catppuccin Macchiato Theme Palette
export THEME_NAME="catppuccin-macchiato"
export YAZI_FLAVOR="catppuccin-macchiato"

# Main Colors
export CLR_ROSEWATER="#f4dbd6"
export CLR_FLAMINGO="#f0c6c6"
export CLR_PINK="#f5bde6"
export CLR_MAUVE="#c6a0f6"
export CLR_RED="#ed8796"
export CLR_MAROON="#ee99a0"
export CLR_PEACH="#f5a97f"
export CLR_YELLOW="#eed49f"
export CLR_GREEN="#a6da95"
export CLR_TEAL="#8bd5ca"
export CLR_SKY="#91d7e3"
export CLR_SAPPHIRE="#7dc4e4"
export CLR_BLUE="#8aadf4"
export CLR_LAVENDER="#b7bdf8"

# Surfaces & Backgrounds
export CLR_TEXT="#cad3f5"
export CLR_SUBTEXT1="#b8c0e0"
export CLR_SUBTEXT0="#a5adcb"
export CLR_OVERLAY2="#939ab7"
export CLR_OVERLAY1="#8087a2"
export CLR_OVERLAY0="#6e738d"
export CLR_SURFACE2="#5b6078"
export CLR_SURFACE1="#494d64"
export CLR_SURFACE0="#363a4f"
export CLR_BASE="#24273a"
export CLR_MANTLE="#1e2030"
export CLR_CRUST="#181926"

# FZF Integration
export FZF_DEFAULT_OPTS=" \
--color=bg+:$CLR_SURFACE0,bg:$CLR_BASE,spinner:$CLR_ROSEWATER,hl:$CLR_RED \
--color=fg:$CLR_TEXT,header:$CLR_RED,info:$CLR_MAUVE,pointer:$CLR_ROSEWATER \
--color=marker:$CLR_ROSEWATER,fg+:$CLR_TEXT,prompt:$CLR_MAUVE,hl+:$CLR_RED"

# Bat Theme
export BAT_THEME="Catppuccin Macchiato"

# Btop Theme
export BTOP_THEME="catppuccin_macchiato"

# Spaceship Integration
export SPACESHIP_CLR_DIR="$CLR_FLAMINGO"
export SPACESHIP_CLR_GIT="$CLR_PEACH"
export SPACESHIP_CLR_EXEC="$CLR_YELLOW"
export SPACESHIP_CLR_AI="$CLR_ROSEWATER"
export SPACESHIP_CLR_CLAUDE="magenta"
export SPACESHIP_CLR_GEMINI="cyan"
export SPACESHIP_CLR_TIME="$CLR_MAROON"
export SPACESHIP_CLR_USER="$CLR_TEXT"
export SPACESHIP_CLR_HOST="$CLR_RED"

# Re-map Spaceship sections
export SPACESHIP_DIR_COLOR="$SPACESHIP_CLR_DIR"
export SPACESHIP_GIT_COLOR="$SPACESHIP_CLR_GIT"
export SPACESHIP_EXEC_TIME_COLOR="$SPACESHIP_CLR_EXEC"
export SPACESHIP_TIME_COLOR="$SPACESHIP_CLR_TIME"
export SPACESHIP_USER_COLOR="$SPACESHIP_CLR_USER"
export SPACESHIP_HOST_COLOR="$SPACESHIP_CLR_HOST"
