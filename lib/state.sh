#!/usr/bin/env bash

state_file() {
  printf '%s/state/installed.yaml\n' "$AI_DEV_ROOT"
}

state_init() {
  mkdir -p "$AI_DEV_ROOT/state"
  [[ -f "$(state_file)" ]] || printf 'installed:\n' >"$(state_file)"
}

state_mark() {
  local component="$1"
  local status="$2"
  local version="${3:-unknown}"
  state_init
  {
    printf '  %s:\n' "$component"
    printf '    status: %s\n' "$status"
    printf '    version: "%s"\n' "$version"
    printf '    updated_at: "%s"\n' "$(ai_dev_timestamp)"
  } >>"$(state_file)"
}

state_set_enabled() {
  local component="$1"
  local status="$2"
  state_init
  {
    printf '  %s:\n' "$component"
    printf '    status: %s\n' "$status"
    printf '    updated_at: "%s"\n' "$(ai_dev_timestamp)"
  } >>"$(state_file)"
}

state_installed_components() {
  state_init
  awk '/^  [A-Za-z0-9_.-]+:$/ { gsub(":","",$1); print $1 }' "$(state_file)" | sort -u
}

state_print() {
  state_init
  cat "$(state_file)"
}
