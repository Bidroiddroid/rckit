#!/usr/bin/env bash

run_cmd() {
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    printf 'DRY-RUN:'
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_command() {
  command_exists "$1" || die "Required command not found: $1"
}

version_at_least() {
  local actual="$1" minimum="$2"
  [[ "$(printf '%s\n%s\n' "$minimum" "$actual" | sort -V | head -n1)" == "$minimum" ]]
}

download_and_run() {
  local url="$1"
  shift
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    printf 'DRY-RUN: download %s and run with' "$url"
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi
  require_command curl
  local script
  script="$(mktemp)"
  if ! curl --proto '=https' --tlsv1.2 -fsSL "$url" -o "$script"; then
    rm -f "$script"
    die "Failed to download official installer: $url"
  fi
  bash "$script" "$@"
  rm -f "$script"
}
