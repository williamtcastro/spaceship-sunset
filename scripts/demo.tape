# vhs tape for the spaceship-sunset demo.
# Generate:   vhs scripts/demo.tape   (writes docs/gallery/demo.gif)
# Prereq:     vhs (https://github.com/charmbracelet/vhs) + a Nerd Font installed

Output docs/gallery/demo.gif

Set FontSize 14
Set FontFamily "JetBrainsMono Nerd Font"
Set Width 1100
Set Height 520
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 45ms
Set PlaybackSpeed 1.0

# Clean shell targeting the installed theme.
Hide
Type "clear" Enter
Sleep 300ms
Show

Type "# spaceship-sunset — one command rewrites every tool's theme"
Sleep 1.5s
Enter

Type "set_theme charcoal-vibrant-orange"
Sleep 500ms
Enter
Sleep 2s

Type "# bat, btop, yazi, ghostty, wezterm, lazygit, delta, cmux all follow"
Sleep 1.5s
Enter

Type "bat --list-themes | grep -i $(cat ~/.spaceship-sunset/state/active_theme | head -c 4)"
Sleep 500ms
Enter
Sleep 2s

Type "set_theme catppuccin-mocha"
Sleep 500ms
Enter
Sleep 2s

Type "set_theme nord-vibrant-orange"
Sleep 500ms
Enter
Sleep 2.5s
