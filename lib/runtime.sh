#!/usr/bin/env bash

runtime_source_module() {
  local component="$1"
  local module
  module="$(catalog_module_for "$component")"
  unset AI_DEV_MODULE_NAME AI_DEV_MODULE_BINARY AI_DEV_MODULE_APT_PACKAGES
  # shellcheck disable=SC1090
  source "$AI_DEV_ROOT/$module/module.sh"
}

runtime_call() {
  local component="$1"
  local operation="$2"
  runtime_source_module "$component"
  local fn="module_${operation}"
  if declare -F "$fn" >/dev/null 2>&1; then
    "$fn" "$component"
  else
    die "Module $component does not implement $operation"
  fi
}

runtime_execute_plan() {
  local action="$1"
  shift || true
  local component
  for component in "$@"; do
    log_info "$action $component"
    case "$action" in
      install)
        if runtime_call "$component" verify; then
          log_info "$component already verified; skipping install"
          state_mark "$component" installed verified
        else
          runtime_call "$component" install
          runtime_call "$component" configure
          if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
            log_info "Dry-run skipped final verification for $component"
          else
            runtime_call "$component" verify
            state_mark "$component" installed verified
          fi
        fi
        ;;
      update)
        runtime_call "$component" update
        if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
          log_info "Dry-run skipped final verification for $component"
        else
          runtime_call "$component" verify
          state_mark "$component" updated verified
        fi
        ;;
      remove)
        runtime_call "$component" remove
        state_mark "$component" removed unknown
        ;;
      *) die "Unsupported planned action: $action" ;;
    esac
  done
}

runtime_verify() {
  local failed=0 component category
  printf 'AI DEV BOOTSTRAP - VERIFICATION\n'
  for component in "$@"; do
    category="$(catalog_category_for "$component")"
    if runtime_call "$component" verify; then
      printf '[OK]   %-16s %s\n' "$category" "$component"
    else
      printf '[FAIL] %-16s %s\n' "$category" "$component"
      failed=1
    fi
  done
  [[ "$failed" -eq 0 ]] && printf 'Environment: READY\n' || printf 'Environment: UNHEALTHY\n'
  return "$failed"
}

runtime_doctor() {
  local component
  printf 'AI DEV BOOTSTRAP - DOCTOR\n'
  platform_print
  for component in "$@"; do
    runtime_call "$component" doctor || true
  done
}
