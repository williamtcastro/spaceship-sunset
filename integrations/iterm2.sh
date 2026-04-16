#!/usr/bin/env bash
# iTerm2 integration (macOS) — write a Dynamic Profile JSON so iTerm2
# auto-reloads the palette without a restart. Users must select the
# "Spaceship Sunset" profile once in iTerm2 → Settings → Profiles (or mark
# it as default) to apply it. Subsequent theme switches update in place.

_sss_iterm2_sync() {
  [[ "$OSTYPE" == darwin* ]] || { _sss_debug "iterm2: skipped — not macOS ($OSTYPE)"; return 0; }

  local theme="${1:-$ACTIVE_THEME}"
  [[ -n "$theme" ]] || { _sss_debug "iterm2: skipped — theme unset"; return 0; }
  [[ -n "$CLR_BASE" ]] || { _sss_debug "iterm2: skipped — CLR_BASE unset"; return 0; }

  local profiles_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  mkdir -p "$profiles_dir"
  local out="$profiles_dir/spaceship-sunset.json"

  # Hex "#RRGGBB" → iTerm2 color dict (sRGB components as 0..1 floats).
  _sss_iterm2_color() {
    local key="$1" hex="${2#\#}"
    local r g b
    r=$(awk -v v=$((16#${hex:0:2})) 'BEGIN { printf "%.10f", v/255 }')
    g=$(awk -v v=$((16#${hex:2:2})) 'BEGIN { printf "%.10f", v/255 }')
    b=$(awk -v v=$((16#${hex:4:2})) 'BEGIN { printf "%.10f", v/255 }')
    printf '    "%s" : { "Color Space":"sRGB", "Red Component":%s, "Green Component":%s, "Blue Component":%s, "Alpha Component":1 }' \
      "$key" "$r" "$g" "$b"
  }

  {
    printf '{\n  "Profiles": [{\n'
    printf '    "Name": "Spaceship Sunset",\n'
    printf '    "Guid": "spaceship-sunset-dynamic-profile",\n'
    _sss_iterm2_color "Background Color"    "$CLR_BASE";      printf ',\n'
    _sss_iterm2_color "Foreground Color"    "$CLR_TEXT";      printf ',\n'
    _sss_iterm2_color "Bold Color"          "$CLR_TEXT";      printf ',\n'
    _sss_iterm2_color "Cursor Color"        "$CLR_ROSEWATER"; printf ',\n'
    _sss_iterm2_color "Cursor Text Color"   "$CLR_BASE";      printf ',\n'
    _sss_iterm2_color "Selection Color"     "$CLR_SURFACE2";  printf ',\n'
    _sss_iterm2_color "Selected Text Color" "$CLR_TEXT";      printf ',\n'
    _sss_iterm2_color "Link Color"          "$CLR_BLUE";      printf ',\n'
    _sss_iterm2_color "Badge Color"         "$CLR_RED";       printf ',\n'
    _sss_iterm2_color "Ansi 0 Color"        "$CLR_SURFACE1";  printf ',\n'
    _sss_iterm2_color "Ansi 1 Color"        "$CLR_RED";       printf ',\n'
    _sss_iterm2_color "Ansi 2 Color"        "$CLR_GREEN";     printf ',\n'
    _sss_iterm2_color "Ansi 3 Color"        "$CLR_YELLOW";    printf ',\n'
    _sss_iterm2_color "Ansi 4 Color"        "$CLR_BLUE";      printf ',\n'
    _sss_iterm2_color "Ansi 5 Color"        "$CLR_PINK";      printf ',\n'
    _sss_iterm2_color "Ansi 6 Color"        "$CLR_TEAL";      printf ',\n'
    _sss_iterm2_color "Ansi 7 Color"        "$CLR_SUBTEXT1";  printf ',\n'
    _sss_iterm2_color "Ansi 8 Color"        "$CLR_SURFACE2";  printf ',\n'
    _sss_iterm2_color "Ansi 9 Color"        "$CLR_RED";       printf ',\n'
    _sss_iterm2_color "Ansi 10 Color"       "$CLR_GREEN";     printf ',\n'
    _sss_iterm2_color "Ansi 11 Color"       "$CLR_YELLOW";    printf ',\n'
    _sss_iterm2_color "Ansi 12 Color"       "$CLR_BLUE";      printf ',\n'
    _sss_iterm2_color "Ansi 13 Color"       "$CLR_MAUVE";     printf ',\n'
    _sss_iterm2_color "Ansi 14 Color"       "$CLR_SAPPHIRE";  printf ',\n'
    _sss_iterm2_color "Ansi 15 Color"       "$CLR_TEXT";      printf '\n'
    printf '  }]\n}\n'
  } > "$out"
  _sss_debug "iterm2: wrote dynamic profile $out"
}
