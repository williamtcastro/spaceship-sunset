# vhs tape for the spaceship-sunset demo.
# Generate:   vhs scripts/demo.tape   (writes docs/gallery/demo.gif)
# Prereq:     vhs (https://github.com/charmbracelet/vhs) + a Nerd Font installed

Output docs/gallery/demo.gif

Set Shell "zsh"
Env COLORTERM "truecolor"
Env TERM "xterm-256color"
Set FontSize 14
Set FontFamily "JetBrainsMono Nerd Font"
Set Width 1100
Set Height 520
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
Sleep 800ms
Show

Type "# spaceship-sunset — one command rewrites every tool's theme"
Sleep 1.2s
Enter

Type "set_theme charcoal-vibrant-orange"
Sleep 400ms
Enter
Sleep 1.2s
# Reload palette + prompt so the new colors render live.
Hide
Type "source ~/spaceship-sunset/lib/init.zsh && source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh && clear"
Enter
Sleep 500ms
Show
Type "# charcoal-vibrant-orange now active"
Sleep 1.5s
Enter

Type "set_theme catppuccin-mocha"
Sleep 400ms
Enter
Sleep 1.2s
Hide
Type "source ~/spaceship-sunset/lib/init.zsh && source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh && clear"
Enter
Sleep 500ms
Show
Type "# catppuccin-mocha"
Sleep 1.5s
Enter

Type "set_theme nord-vibrant-orange"
Sleep 400ms
Enter
Sleep 1.2s
Hide
Type "source ~/spaceship-sunset/lib/init.zsh && source ~/.local/share/zinit/plugins/spaceship-prompt---spaceship-prompt/spaceship.zsh && clear"
Enter
Sleep 500ms
Show
Type "# nord-vibrant-orange (default)"
Sleep 2s
Enter
