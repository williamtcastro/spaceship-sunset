#!/usr/bin/env zsh
# spaceship_gemini — Spaceship prompt section showing Gemini model + API status.
# Format:  F2.0 󰄴
# Gracefully hides itself if `gemini` command is unavailable.

_GEMINI_STATUS_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/spaceship-sunset/gemini_status"

_update_gemini_status() {
  local lock_file="${_GEMINI_STATUS_CACHE}.lock"
  [[ -f "$lock_file" ]] && return
  touch "$lock_file"

  local api_http=$(curl -sIL -o /dev/null -w "%{http_code}" --connect-timeout 2 \
    https://generativelanguage.googleapis.com/v1beta/models 2>/dev/null)
  local status="ok"
  [[ "$api_http" != "200" && "$api_http" != "302" && "$api_http" != "401" ]] && status="down"

  if [[ "$status" == "ok" ]]; then
    local start=$(date +%s%N)
    curl -sIL -o /dev/null https://generativelanguage.googleapis.com/v1beta/models --connect-timeout 2 2>/dev/null
    local end=$(date +%s%N)
    local lat=$(( (end - start) / 1000000 ))
    (( lat > 800 )) && status="slow"
  fi

  print -- "$status" > "$_GEMINI_STATUS_CACHE"
  rm -f "$lock_file"
}

spaceship_gemini() {
  command -v gemini >/dev/null || return

  local settings_file="$HOME/.gemini/settings.json"
  local model

  if [[ -f "$settings_file" ]] && command -v jq >/dev/null; then
    local mtime=$(stat -f %m "$settings_file" 2>/dev/null || stat -c %Y "$settings_file" 2>/dev/null)
    if [[ "$mtime" == "$_GEMINI_PROMPT_MTIME" ]]; then
      model="$_GEMINI_PROMPT_CACHE"
    else
      model=$(jq -r '.model.name' "$settings_file" 2>/dev/null)
      export _GEMINI_PROMPT_MTIME="$mtime"
      export _GEMINI_PROMPT_CACHE="$model"
    fi
  fi

  [[ -z "$model" || "$model" == "null" ]] && model="${GEMINI_CODE_MODEL:-2.0 Flash}"

  local api_status="ok"
  if [[ -f "$_GEMINI_STATUS_CACHE" ]]; then
    local cache_mtime=$(stat -f %m "$_GEMINI_STATUS_CACHE" 2>/dev/null || stat -c %Y "$_GEMINI_STATUS_CACHE" 2>/dev/null)
    local now=$(date +%s)
    if (( now - cache_mtime > 300 )); then
      _update_gemini_status &!
    fi
    api_status=$(<"$_GEMINI_STATUS_CACHE")
  else
    mkdir -p "${_GEMINI_STATUS_CACHE:h}"
    _update_gemini_status &!
  fi

  local status_color="${SPACESHIP_CLR_GEMINI:-blue}"
  local status_icon="󰄴"
  case "$api_status" in
    slow) status_color="yellow"; status_icon="󰀦" ;;
    down) status_color="red";    status_icon="󰅙" ;;
  esac

  local symbol=""
  local short_model=""
  if [[ "$model" == *Flash* ]]; then short_model="F"
  elif [[ "$model" == *Pro* ]]; then short_model="P"
  elif [[ "$model" == *Ultra* ]]; then short_model="U"
  elif [[ "$model" == auto-gemini-* ]]; then short_model="A"
  else short_model="G"
  fi

  local version=$(print -- "$model" | grep -oE "[0-9]+(\.[0-9]+)?")
  [[ -n "$version" ]] && short_model="${short_model}${version}"

  spaceship::section::v3 "$status_color" "" "$symbol $short_model $status_icon" " · "
}
