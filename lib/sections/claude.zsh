#!/usr/bin/env zsh
# spaceship_claude — Spaceship prompt section showing Claude Code model + effort + API status.
# Format: 󱜙 S4.6 [M] 󰄴
# Gracefully hides itself if `claude` command is unavailable.

_CLAUDE_STATUS_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/spaceship-sunset/claude_status"
_CLAUDE_VERSIONS_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/spaceship-sunset/claude_model_versions"

_claude_real_binary() {
  local bin=$(command ls -t "$HOME/.local/share/claude/versions/"*(.N) 2>/dev/null | head -n1)
  [[ -n "$bin" && -f "$bin" ]] && { print -- "$bin"; return }
  bin=$(readlink -f "$(command -v claude)" 2>/dev/null)
  [[ -n "$bin" && -f "$bin" ]] && file "$bin" 2>/dev/null | grep -q "Mach-O" && print -- "$bin"
}

# Latest versioned alias (opus/sonnet/haiku) derived from the claude binary.
# Cached per-binary-mtime so `strings` only runs when claude is upgraded.
_claude_latest_version() {
  local family="$1"
  local bin=$(_claude_real_binary)
  [[ -z "$bin" ]] && return
  local bin_mtime=$(stat -f %m "$bin" 2>/dev/null || stat -c %Y "$bin" 2>/dev/null)

  if [[ ! -s "$_CLAUDE_VERSIONS_CACHE" || "$(head -n1 "$_CLAUDE_VERSIONS_CACHE" 2>/dev/null)" != "$bin_mtime" ]]; then
    mkdir -p "${_CLAUDE_VERSIONS_CACHE:h}"
    local tmp=$(mktemp) all
    all=$(strings "$bin" 2>/dev/null \
      | grep -oE "claude-(opus|sonnet|haiku)-[0-9]+-[0-9]{1,2}\b")
    {
      print -- "$bin_mtime"
      for f in opus sonnet haiku; do
        print -- "$all" | grep "^claude-${f}-" \
          | sed -E "s/^claude-${f}-//; s/-/./" \
          | sort -V | tail -n1 | xargs -I{} printf '%s=%s\n' "$f" "{}"
      done
    } > "$tmp" && mv "$tmp" "$_CLAUDE_VERSIONS_CACHE"
  fi

  grep "^${family}=" "$_CLAUDE_VERSIONS_CACHE" 2>/dev/null | cut -d= -f2
}

_update_claude_status() {
  local lock_file="${_CLAUDE_STATUS_CACHE}.lock"
  [[ -f "$lock_file" ]] && return
  touch "$lock_file"

  local c_json=$(curl -sL --connect-timeout 2 https://status.anthropic.com/api/v2/summary.json 2>/dev/null)
  local status="ok"
  if [[ -n "$c_json" ]] && command -v jq >/dev/null; then
    local indicator=$(print -- "$c_json" | jq -r '.status.indicator' 2>/dev/null)
    case "$indicator" in
      none) status="ok" ;;
      minor) status="slow" ;;
      *) status="down" ;;
    esac
  else
    status="down"
  fi

  print -- "$status" > "$_CLAUDE_STATUS_CACHE"
  rm -f "$lock_file"
}

spaceship_claude() {
  command -v claude >/dev/null || return

  local settings_file="$HOME/.claude/settings.json"
  local model effort

  if [[ -f "$settings_file" ]] && command -v jq >/dev/null; then
    local mtime=$(stat -f %m "$settings_file" 2>/dev/null || stat -c %Y "$settings_file" 2>/dev/null)
    if [[ "$mtime" == "$_CLAUDE_PROMPT_MTIME" ]]; then
      model="$_CLAUDE_PROMPT_MODEL_CACHE"
      effort="$_CLAUDE_PROMPT_EFFORT_CACHE"
    else
      model=$(jq -r '.model // empty' "$settings_file" 2>/dev/null)
      effort=$(jq -r '.effortLevel // empty' "$settings_file" 2>/dev/null)
      export _CLAUDE_PROMPT_MTIME="$mtime"
      export _CLAUDE_PROMPT_MODEL_CACHE="$model"
      export _CLAUDE_PROMPT_EFFORT_CACHE="$effort"
    fi
  fi

  [[ -z "$model"  ]] && model="${CLAUDE_CODE_MODEL:-Sonnet}"
  [[ -z "$effort" ]] && effort="${CLAUDE_CODE_EFFORT_LEVEL:-medium}"

  local api_status="ok"
  if [[ -f "$_CLAUDE_STATUS_CACHE" ]]; then
    local cache_mtime=$(stat -f %m "$_CLAUDE_STATUS_CACHE" 2>/dev/null || stat -c %Y "$_CLAUDE_STATUS_CACHE" 2>/dev/null)
    local now=$(date +%s)
    if (( now - cache_mtime > 300 )); then
      _update_claude_status &!
    fi
    api_status=$(<"$_CLAUDE_STATUS_CACHE")
  else
    mkdir -p "${_CLAUDE_STATUS_CACHE:h}"
    _update_claude_status &!
  fi

  local status_color="${SPACESHIP_CLR_CLAUDE:-magenta}"
  local status_icon="󰄴"
  case "$api_status" in
    slow) status_color="yellow"; status_icon="󰀦" ;;
    down) status_color="red";    status_icon="󰅙" ;;
  esac

  local symbol="󱜙"
  local short_model family
  case "${model:l}" in
    opus*)      short_model="O"; family="opus" ;;
    sonnet*)    short_model="S"; family="sonnet" ;;
    haiku*)     short_model="H"; family="haiku" ;;
    *default*)  short_model="D" ;;
    *)          short_model="${(U)model:0:1}" ;;
  esac
  local version=$(print -- "$model" | grep -oE "[0-9]+\.[0-9]+")
  [[ -z "$version" && -n "$family" ]] && version=$(_claude_latest_version "$family")
  [[ -n "$version" ]] && short_model="${short_model}${version}"

  local effort_letter
  case "${effort:l}" in
    none)           effort_letter="" ;;
    minimal)        effort_letter="m" ;;
    low)            effort_letter="L" ;;
    medium)         effort_letter="M" ;;
    high)           effort_letter="H" ;;
    xhigh)          effort_letter="X" ;;
    max|maximum)    effort_letter="!" ;;
    auto|adaptive)  effort_letter="A" ;;
    *)              effort_letter="${(U)effort:0:1}" ;;
  esac

  local content="$symbol $short_model"
  [[ -n "$effort_letter" ]] && content="$content [$effort_letter]"
  content="$content $status_icon"

  spaceship::section::v3 "$status_color" "" "$content" " · "
}
