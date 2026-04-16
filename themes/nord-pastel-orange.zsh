# Nord Pastel Orange Theme Palette
export THEME_NAME="nord-pastel-orange"
export YAZI_FLAVOR="nord"

# Main Colors (Nord adapted)
export CLR_ROSEWATER="#FFF0E0"
export CLR_FLAMINGO="#FFE0C0"
export CLR_PINK="#FFD0B5"
export CLR_MAUVE="#D4A070"
export CLR_RED="#FF875F"
export CLR_MAROON="#FFD1B0"
export CLR_PEACH="#FFB86C"
export CLR_YELLOW="#FFE4B5"
export CLR_GREEN="#A3BE8C"
export CLR_TEAL="#88C0D0"
export CLR_SKY="#81A1C1"
export CLR_SAPPHIRE="#81A1C1"
export CLR_BLUE="#5E81AC"
export CLR_LAVENDER="#FFE8D0"

# Surfaces & Backgrounds
export CLR_TEXT="#D8DEE9"
export CLR_SUBTEXT1="#E5E9F0"
export CLR_SUBTEXT0="#D8DEE9"
export CLR_OVERLAY2="#4C566A"
export CLR_OVERLAY1="#4C566A"
export CLR_OVERLAY0="#4C566A"
export CLR_SURFACE2="#434C5E"
export CLR_SURFACE1="#3B4252"
export CLR_SURFACE0="#3B4252"
export CLR_BASE="#2E3440"
export CLR_MANTLE="#2E3440"
export CLR_CRUST="#2E3440"

# FZF Integration
export FZF_DEFAULT_OPTS=" \
--color=bg+:$CLR_SURFACE0,bg:$CLR_BASE,spinner:$CLR_ROSEWATER,hl:$CLR_RED \
--color=fg:$CLR_TEXT,header:$CLR_RED,info:$CLR_MAUVE,pointer:$CLR_ROSEWATER \
--color=marker:$CLR_ROSEWATER,fg+:$CLR_TEXT,prompt:$CLR_MAUVE,hl+:$CLR_RED"

# Bat Theme
export BAT_THEME="Nord"

# Btop Theme
export BTOP_THEME="nord"

# WezTerm color scheme — pass the palette name through.
export WEZTERM_COLOR_SCHEME="$THEME_NAME"

# Lazygit accent colors — warm-palette variant pairs the orange ramp.
export LAZYGIT_ACTIVE_BORDER="$CLR_PEACH"
export LAZYGIT_OPTIONS_TEXT="$CLR_ROSEWATER"
export LAZYGIT_CHERRY_FG="$CLR_FLAMINGO"

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
