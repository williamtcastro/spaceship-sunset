# Catppuccin Mocha Theme Palette
export THEME_NAME="catppuccin-mocha"
export YAZI_FLAVOR="catppuccin-mocha"

# Main Colors
export CLR_ROSEWATER="#f5e0dc"
export CLR_FLAMINGO="#f2cdcd"
export CLR_PINK="#f5c2e7"
export CLR_MAUVE="#cba6f7"
export CLR_RED="#f38ba8"
export CLR_MAROON="#eba0ac"
export CLR_PEACH="#fab387"
export CLR_YELLOW="#f9e2af"
export CLR_GREEN="#a6e3a1"
export CLR_TEAL="#94e2d5"
export CLR_SKY="#89dceb"
export CLR_SAPPHIRE="#74c7ec"
export CLR_BLUE="#89b4fa"
export CLR_LAVENDER="#b4befe"

# Surfaces & Backgrounds
export CLR_TEXT="#cdd6f4"
export CLR_SUBTEXT1="#bac2de"
export CLR_SUBTEXT0="#a6adc8"
export CLR_OVERLAY2="#9399b2"
export CLR_OVERLAY1="#7f849c"
export CLR_OVERLAY0="#6c7086"
export CLR_SURFACE2="#585b70"
export CLR_SURFACE1="#45475a"
export CLR_SURFACE0="#313244"
export CLR_BASE="#1e1e2e"
export CLR_MANTLE="#181825"
export CLR_CRUST="#11111b"

# FZF Integration
export FZF_DEFAULT_OPTS=" \
--color=bg+:$CLR_SURFACE0,bg:$CLR_BASE,spinner:$CLR_ROSEWATER,hl:$CLR_RED \
--color=fg:$CLR_TEXT,header:$CLR_RED,info:$CLR_MAUVE,pointer:$CLR_ROSEWATER \
--color=marker:$CLR_ROSEWATER,fg+:$CLR_TEXT,prompt:$CLR_MAUVE,hl+:$CLR_RED"

# Bat Theme
export BAT_THEME="Catppuccin Mocha"

# Btop Theme
export BTOP_THEME="catppuccin_mocha"

# WezTerm color scheme (name wezterm resolves internally)
export WEZTERM_COLOR_SCHEME="Catppuccin Mocha"

# Lazygit accent colors — palette picks which CLR_* reads as the accent.
# Cool-palette catppuccin variants read nicer with teal/blue accents than orange.
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
