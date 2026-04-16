# spaceship-sunset

A warm-orange Spaceship prompt with six coordinated terminal palettes — one
`set_theme` command rewrites bat, btop, yazi, ghostty, wezterm, lazygit, nvim,
delta, and cmux to match.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/williamtcastro/spaceship-sunset/main/install.sh)"
```

> **Requires a [Nerd Font](https://www.nerdfonts.com/) (v3.0+) set as your
> terminal font.** Without one, the prompt glyphs render as boxes.

## Palettes

- `nord-vibrant-orange` (default)
- `nord-pastel-orange`
- `charcoal-vibrant-orange`
- `catppuccin-mocha`
- `catppuccin-macchiato`
- `catppuccin-frappe`

Switch anytime: `set_theme` (fzf picker, or falls back to `select` menu).

## Non-interactive install

```bash
SPACESHIP_SUNSET_THEME=catppuccin-mocha bash -c "$(curl -fsSL .../install.sh)"
# or
bash install.sh --theme=catppuccin-mocha
```

## What it installs

- `~/.spaceship-sunset/` — the repo checkout plus `state/active_theme` and an
  opt-in `config` file listing enabled integrations.
- A managed block in `~/.zshrc` (delimited by
  `# >>> spaceship-sunset >>>` / `# <<< spaceship-sunset <<<`) that sources
  the entrypoint.
- A `~/.zshrc.spaceship-sunset.bak` snapshot (cleaned up on uninstall).
- `*.spaceship-sunset.bak` snapshots beside every tool config it rewrites,
  so uninstall fully restores your previous state.

## Uninstall

```bash
bash ~/.spaceship-sunset/uninstall.sh
```

Removes the managed block, restores every snapshot, and deletes
`~/.spaceship-sunset` plus its cache.

## How it works

See [docs/DESIGN.md](docs/DESIGN.md) for the prompt layout rationale and
[docs/CREATING_THEMES.md](docs/CREATING_THEMES.md) for the `CLR_*` /
`SPACESHIP_CLR_*` contract a palette must implement.

## Prerequisites

- `zsh`
- [Spaceship Prompt](https://spaceship-prompt.sh) — install via your plugin
  manager (zinit: `zinit light spaceship-prompt/spaceship-prompt`).
- Nerd Font (see above).
- Optional: `fzf` (for the theme picker), `jq` (for live model/effort display
  in the Claude / Gemini prompt sections).

## Attribution

See [ATTRIBUTION.md](ATTRIBUTION.md).

## License

MIT. See [LICENSE](LICENSE).
