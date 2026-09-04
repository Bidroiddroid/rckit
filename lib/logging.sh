#!/usr/bin/env bash

ai_dev_timestamp() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}

log_file_for() {
  local name="${1:-ai-dev}"
  mkdir -p "$AI_DEV_ROOT/logs"
  printf '%s/logs/%s.log\n' "$AI_DEV_ROOT" "$name"
}

log_line() {
  local level="$1"
  shift
  local message="$*"
  local line
  line="$(printf '%s [%s] %s' "$(ai_dev_timestamp)" "$level" "$message")"
  printf '%s\n' "$line"
  if [[ "${AI_DEV_DRY_RUN:-0}" != "1" ]]; then
    printf '%s\n' "$line" >>"$(log_file_for "${AI_DEV_COMMAND:-ai-dev}")"
  fi
}

log_info() {
  log_line INFO "$@"
}

log_warn() {
  log_line WARN "$@"
}

log_error() {
  log_line ERROR "$@" >&2
  if [[ "${AI_DEV_DRY_RUN:-0}" != "1" ]]; then
    printf '%s [%s] %s\n' "$(ai_dev_timestamp)" ERROR "$*" >>"$(log_file_for error)"
  fi
}

die() {
  log_error "$@"
  exit 1
}
