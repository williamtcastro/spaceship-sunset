# Attribution

spaceship-sunset builds on several upstream projects. Each retains its own
license; this project is MIT.

## Palettes

- **Catppuccin** — MIT License. Upstream:
  [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin).
  Used for `catppuccin-frappe`, `catppuccin-macchiato`, and `catppuccin-mocha`
  palettes and their `CLR_*` / surface color values.

- **Nord** — MIT License. Upstream:
  [nordtheme/nord](https://github.com/nordtheme/nord).
  Adapted for `nord-pastel-orange` and `nord-vibrant-orange` palettes,
  with warm-orange accents layered over the Nord base.

## Prompt

- **Spaceship Prompt** — MIT License. Upstream:
  [spaceship-prompt/spaceship-prompt](https://github.com/spaceship-prompt/spaceship-prompt).
  spaceship-sunset is a configuration layer; it does not fork or vendor the
  prompt itself.

## Tool integrations

Tool config writers in `integrations/` target each tool's native format. They
do not include upstream code, only writes that match the respective config
schema. See each tool's own project for license:

- bat, btop, yazi, ghostty, wezterm, tmux, lazygit, neovim, delta, cmux.
