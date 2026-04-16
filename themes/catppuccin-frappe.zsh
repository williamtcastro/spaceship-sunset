# Catppuccin Frappe Theme Palette
export THEME_NAME="catppuccin-frappe"
export YAZI_FLAVOR="catppuccin-frappe"

# Main Colors
export CLR_ROSEWATER="#f2d5cf"
export CLR_FLAMINGO="#eebebe"
export CLR_PINK="#f4b8e4"
export CLR_MAUVE="#ca9ee6"
export CLR_RED="#e78284"
export CLR_MAROON="#ea999c"
export CLR_PEACH="#ef9f76"
export CLR_YELLOW="#e5c890"
export CLR_GREEN="#a6d189"
export CLR_TEAL="#81c8be"
export CLR_SKY="#99d1db"
export CLR_SAPPHIRE="#85c1dc"
export CLR_BLUE="#8caaee"
export CLR_LAVENDER="#babbf1"

# Surfaces & Backgrounds
export CLR_TEXT="#c6d0f5"
export CLR_SUBTEXT1="#b5bfe2"
export CLR_SUBTEXT0="#a5adce"
export CLR_OVERLAY2="#949cbb"
export CLR_OVERLAY1="#838ba7"
export CLR_OVERLAY0="#737994"
export CLR_SURFACE2="#626880"
export CLR_SURFACE1="#51576d"
export CLR_SURFACE0="#414559"
export CLR_BASE="#303446"
export CLR_MANTLE="#292c3c"
export CLR_CRUST="#232634"

# FZF Integration
export FZF_DEFAULT_OPTS=" \
--color=bg+:$CLR_SURFACE0,bg:$CLR_BASE,spinner:$CLR_ROSEWATER,hl:$CLR_RED \
--color=fg:$CLR_TEXT,header:$CLR_RED,info:$CLR_MAUVE,pointer:$CLR_ROSEWATER \
--color=marker:$CLR_ROSEWATER,fg+:$CLR_TEXT,prompt:$CLR_MAUVE,hl+:$CLR_RED"

# Bat Theme
export BAT_THEME="Catppuccin Frappe"

# Btop Theme
export BTOP_THEME="catppuccin_frappe"

# WezTerm color scheme (name wezterm resolves internally)
export WEZTERM_COLOR_SCHEME="Catppuccin Frappe"

# Lazygit accent colors — cool-palette catppuccin reads nicer with teal/blue.
export LAZYGIT_ACTIVE_BORDER="$CLR_TEAL"
export LAZYGIT_OPTIONS_TEXT="$CLR_BLUE"
export LAZYGIT_CHERRY_FG="$CLR_TEAL"

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
