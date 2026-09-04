#!/usr/bin/env bash
AI_DEV_MODULE_NAME="GitHub CLI"
AI_DEV_MODULE_BINARY="gh"
AI_DEV_MODULE_APT_PACKAGES=(gh)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_doctor() {
  if ! command_exists gh; then
    printf '[WARN] GitHub CLI is not installed.\n'
  elif gh auth status >/dev/null 2>&1; then
    printf '[OK] GitHub CLI is installed and authenticated.\n'
  else
    printf '[WARN] GitHub CLI is installed but not authenticated; run: gh auth login\n'
  fi
}
