#!/usr/bin/env bash

confirm() {
  local message="$1"
  if [[ "${AI_DEV_YES:-0}" == "1" ]]; then
    log_info "$message: yes"
    return 0
  fi
  printf '%s [y/N] ' "$message"
  local answer
  read -r answer || return 1
  [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "YES" ]]
}

confirm_plan() {
  local action="$1"
  if ! confirm "Proceed with $action plan?"; then
    log_warn "Cancelled $action plan"
    exit 0
  fi
}

confirm_destructive() {
  local target="$1"
  confirm "This may be destructive: $target. Continue?" || die "Destructive action cancelled: $target"
}

prompt_select_components() {
  if [[ ! -t 0 ]]; then
    die "No interactive terminal available. Pass components explicitly or use --profile."
  fi
  printf 'Available components:\n' >&2
  local component
  for component in "${AI_DEV_COMPONENTS[@]}"; do
    printf '  - %s\n' "$component" >&2
  done
  printf 'Enter components separated by spaces: ' >&2
  local line
  read -r line || die "Component selection cancelled"
  for component in $line; do
    printf '%s\n' "$component"
  done
}
