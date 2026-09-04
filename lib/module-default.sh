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
  die "$component has no supported installer for $AI_DEV_PACKAGE_MANAGER"
}

module_configure() {
  return 0
}

module_update() {
  local component="$1"
  platform_detect
  if [[ "$AI_DEV_PACKAGE_MANAGER" == "apt" ]] && declare -p AI_DEV_MODULE_APT_PACKAGES >/dev/null 2>&1 && [[ "${#AI_DEV_MODULE_APT_PACKAGES[@]}" -gt 0 ]]; then
    run_cmd sudo apt-get update
    run_cmd sudo apt-get install -y --only-upgrade "${AI_DEV_MODULE_APT_PACKAGES[@]}"
    return 0
  fi
  die "$component has no supported update implementation"
}

module_remove() {
  local component="$1"
  platform_detect
  confirm_destructive "remove component $component"
  if [[ "$AI_DEV_PACKAGE_MANAGER" == "apt" ]] && declare -p AI_DEV_MODULE_APT_PACKAGES >/dev/null 2>&1 && [[ "${#AI_DEV_MODULE_APT_PACKAGES[@]}" -gt 0 ]]; then
    run_cmd sudo apt-get remove -y "${AI_DEV_MODULE_APT_PACKAGES[@]}"
    return 0
  fi
  die "$component has no safe remove implementation"
}

module_doctor() {
  local component="$1"
  if module_verify "$component"; then
    printf '[OK] %s is available\n' "$component"
  else
    printf '[WARN] %s is not available. Install it with ai-dev install %s after reviewing the plan.\n' "$component" "$component"
  fi
}
