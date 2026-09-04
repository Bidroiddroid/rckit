#!/usr/bin/env bash

module_name() {
  printf '%s\n' "${AI_DEV_MODULE_NAME:-$1}"
}

module_binary() {
  printf '%s\n' "${AI_DEV_MODULE_BINARY:-$1}"
}

module_detect() {
  local component="$1"
  command_exists "$(module_binary "$component")"
}

module_verify() {
  module_detect "$1"
}

module_install() {
  local component="$1"
  platform_detect
  if [[ "$AI_DEV_PACKAGE_MANAGER" == "apt" ]] && declare -p AI_DEV_MODULE_APT_PACKAGES >/dev/null 2>&1 && [[ "${#AI_DEV_MODULE_APT_PACKAGES[@]}" -gt 0 ]]; then
    log_info "Installing $component packages with apt: ${AI_DEV_MODULE_APT_PACKAGES[*]}"
    run_cmd sudo apt-get update
    run_cmd sudo apt-get install -y "${AI_DEV_MODULE_APT_PACKAGES[@]}"
    return 0
  fi
  log_info "Install placeholder for $component. Official installer wiring is module-specific."
  [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]] || log_warn "$component installer is not implemented yet; no host changes made"
}

module_configure() {
  local component="$1"
  if [[ "$(catalog_credentials_for "$component" 2>/dev/null || printf false)" == "true" ]]; then
    if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
      log_info "Dry-run skipped credential prompt for $component"
    elif [[ -t 0 ]]; then
      printf 'Enter credential for %s (input hidden, not stored): ' "$component" >&2
      local secret
      read -rs secret || die "Credential input cancelled for $component"
      printf '\n' >&2
      [[ -n "$secret" ]] || die "Credential required for $component"
      unset secret
      log_info "Credential for $component was provided interactively and not written to disk"
    else
      die "$component requires credentials; run interactively or configure credentials outside Git-tracked files"
    fi
  fi
  log_info "Configure placeholder for $component"
}

module_update() {
  log_info "Update placeholder for $1"
}

module_remove() {
  confirm_destructive "remove component $1"
  log_info "Remove placeholder for $1; no user data removed"
}

module_doctor() {
  local component="$1"
  if module_verify "$component"; then
    printf '[OK] %s is available\n' "$component"
  else
    printf '[WARN] %s is not available. Install it with ai-dev install %s after reviewing the plan.\n' "$component" "$component"
  fi
}
