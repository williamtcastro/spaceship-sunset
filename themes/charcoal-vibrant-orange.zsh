# Charcoal Vibrant Orange Theme Palette
export THEME_NAME="charcoal-vibrant-orange"
export YAZI_FLAVOR="dracula"

# Main Colors
export CLR_ROSEWATER="#FFAF5F"
export CLR_FLAMINGO="#FF875F"
export CLR_PINK="#FFCF9D"
export CLR_MAUVE="#D4875A"
export CLR_RED="#FF5F00"
export CLR_MAROON="#D78700"
export CLR_PEACH="#FF9D00"
export CLR_YELLOW="#FFAF00"
export CLR_GREEN="#a6e3a1"
export CLR_TEAL="#94e2d5"
export CLR_SKY="#89dceb"
export CLR_SAPPHIRE="#74c7ec"
export CLR_BLUE="#89b4fa"
export CLR_LAVENDER="#FFE0B2"

# Surfaces & Backgrounds
export CLR_TEXT="#CCCCCC"
export CLR_SUBTEXT1="#BBBBBB"
export CLR_SUBTEXT0="#AAAAAA"
export CLR_OVERLAY2="#888888"
export CLR_OVERLAY1="#777777"
export CLR_OVERLAY0="#666666"
export CLR_SURFACE2="#444444"
export CLR_SURFACE1="#333333"
export CLR_SURFACE0="#2D2D2D"
export CLR_BASE="#1E1E1E"
export CLR_MANTLE="#181818"
export CLR_CRUST="#111111"

# FZF Integration
export FZF_DEFAULT_OPTS=" \
--color=bg+:$CLR_SURFACE0,bg:$CLR_BASE,spinner:$CLR_ROSEWATER,hl:$CLR_RED \
--color=fg:$CLR_TEXT,header:$CLR_RED,info:$CLR_MAUVE,pointer:$CLR_ROSEWATER \
--color=marker:$CLR_ROSEWATER,fg+:$CLR_TEXT,prompt:$CLR_MAUVE,hl+:$CLR_RED"

# Bat Theme
export BAT_THEME="ansi"

# Btop Theme
export BTOP_THEME="tty"

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
