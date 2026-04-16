#!/usr/bin/env zsh
# Generate one SVG swatch per palette under docs/gallery/.
# Each swatch shows the 14 accent colors on top of the surface ramp.
set -euo pipefail

ROOT="${0:A:h:h}"
OUT="$ROOT/docs/gallery"
mkdir -p "$OUT"

accents=(
  CLR_ROSEWATER CLR_FLAMINGO CLR_PINK CLR_MAUVE
  CLR_RED CLR_MAROON CLR_PEACH CLR_YELLOW
  CLR_GREEN CLR_TEAL CLR_SKY CLR_SAPPHIRE
  CLR_BLUE CLR_LAVENDER
)
surfaces=(
  CLR_TEXT CLR_SUBTEXT1 CLR_SUBTEXT0
  CLR_OVERLAY2 CLR_OVERLAY1 CLR_OVERLAY0
  CLR_SURFACE2 CLR_SURFACE1 CLR_SURFACE0
  CLR_BASE CLR_MANTLE CLR_CRUST
)

render_palette() {
  local theme_file="$1"
  local name="${theme_file:t:r}"
  local svg="$OUT/${name}.svg"

  # Source palette in a subshell and emit colors to stdout.
  local palette
  palette=$(zsh -c "
    source '$theme_file'
    for v in $accents $surfaces; do
      printf '%s=%s\n' \$v \${(P)v}
    done
  ")

  typeset -A C
  while IFS='=' read -r k v; do C[$k]="$v"; done <<< "$palette"

  local cell_w=60 cell_h=60 gap=4
  local w=$(( 14 * cell_w + 13 * gap + 32 ))
  local h=$(( 2 * cell_h + gap + 32 + 24 ))  # two rows + title

  {
    print -- "<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'>"
    print -- "  <rect width='100%' height='100%' fill='${C[CLR_BASE]}'/>"
    print -- "  <text x='16' y='22' font-family='system-ui, -apple-system, sans-serif' font-size='14' font-weight='600' fill='${C[CLR_TEXT]}'>${name}</text>"

    local x=16 y=32
    local i=0
    for k in $accents; do
      print -- "  <rect x='$x' y='$y' width='$cell_w' height='$cell_h' rx='6' fill='${C[$k]}'/>"
      x=$(( x + cell_w + gap ))
      i=$(( i + 1 ))
    done

    x=16
    y=$(( y + cell_h + gap ))
    for k in ${surfaces[1,12]}; do
      print -- "  <rect x='$x' y='$y' width='$cell_w' height='$cell_h' rx='6' fill='${C[$k]}' stroke='${C[CLR_OVERLAY0]}' stroke-width='0.5'/>"
      x=$(( x + cell_w + gap ))
    done
    print -- "</svg>"
  } > "$svg"

  print -- "wrote $svg"
}

for f in "$ROOT"/themes/*.zsh; do
  render_palette "$f"
done
