# vhs tape for the spaceship-sunset demo.
# Generate:   vhs scripts/demo.tape   (writes docs/gallery/demo.gif)
# Prereq:     vhs (https://github.com/charmbracelet/vhs) + a Nerd Font installed

Output docs/gallery/demo.gif

Set Shell "zsh"
Env COLORTERM "truecolor"
Env TERM "xterm-256color"
Env SPACESHIP_PROMPT_ASYNC "false"
Set FontSize 14
Set FontFamily "JetBrainsMono Nerd Font"
Set Width 1100
Set Height 560
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 45ms
Set PlaybackSpeed 1.0

# Bootstrap: vhs shells don't source ~/.zshrc, so load Spaceship + spaceship-sunset manually.
Hide
Type "setopt interactive_comments promptsubst"
Enter
Type "source ~/spaceship-sunset/lib/init.zsh"
Enter
Type "source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh"
Enter
Type "clear"
Enter
Sleep 1s
Show

Type "# spaceship-sunset — one command rewrites every tool's theme"
Sleep 1.2s
Enter
Sleep 600ms

# --- charcoal-vibrant-orange (default, saturated orange on charcoal) ---------
Type "set_theme charcoal-vibrant-orange"
Sleep 400ms
Enter
Sleep 1.5s
Hide
Type "source ~/spaceship-sunset/themes/charcoal-vibrant-orange.zsh && source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh && clear"
Enter
Sleep 800ms
Show
Enter
Sleep 500ms
Type "# charcoal-vibrant-orange — the default palette"
Sleep 1.8s
Enter
Sleep 600ms

# --- catppuccin-mocha (pastel pink/peach) -------------------------------------
Type "set_theme catppuccin-mocha"
Sleep 400ms
Enter
Sleep 1.5s
Hide
Type "source ~/spaceship-sunset/themes/catppuccin-mocha.zsh && source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh && clear"
Enter
Sleep 800ms
Show
Enter
Sleep 500ms
Type "# catppuccin-mocha — pastel pink/peach"
Sleep 1.8s
Enter
Sleep 600ms

# --- nord-pastel-orange (cream/peach on nord steel) ---------------------------
Type "set_theme nord-pastel-orange"
Sleep 400ms
Enter
Sleep 1.5s
Hide
Type "source ~/spaceship-sunset/themes/nord-pastel-orange.zsh && source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh && clear"
Enter
Sleep 800ms
Show
Enter
Sleep 500ms
Type "# nord-pastel-orange — cream/peach on nord steel"
Sleep 1.8s
Enter
Sleep 600ms

# --- debug mode showcase — confirms which integrations ran ------------------
Type "# SPACESHIP_SUNSET_DEBUG=1 reveals which integrations ran and which skipped"
Sleep 1.5s
Enter
Sleep 400ms
Type "SPACESHIP_SUNSET_DEBUG=1 set_theme charcoal-vibrant-orange"
Sleep 400ms
Enter
Sleep 2.5s
