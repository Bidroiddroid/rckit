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
  state_upsert "$component" "$status" "$version"
}

state_set_enabled() {
  local component="$1"
  local status="$2"
  state_upsert "$component" "$status" "unknown"
}

state_upsert() {
  local component="$1" status="$2" version="$3" file tmp
  state_init
  file="$(state_file)"
  tmp="$(mktemp)"
  awk -v component="$component" '
    $0 == "  " component ":" { skip=1; next }
    skip && /^  [A-Za-z0-9_.-]+:$/ { skip=0 }
    !skip { print }
  ' "$file" >"$tmp"
  {
    printf '  %s:\n' "$component"
    printf '    status: %s\n' "$status"
    printf '    version: "%s"\n' "$version"
    printf '    updated_at: "%s"\n' "$(ai_dev_timestamp)"
  } >>"$tmp"
  mv "$tmp" "$file"
}

state_installed_components() {
  state_init
  awk '/^  [A-Za-z0-9_.-]+:$/ { gsub(":","",$1); print $1 }' "$(state_file)" | sort -u
}

state_print() {
  state_init
  cat "$(state_file)"
}
