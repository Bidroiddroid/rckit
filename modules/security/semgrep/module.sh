#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Semgrep"
AI_DEV_MODULE_BINARY="semgrep"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  if command_exists python3; then
    run_cmd python3 -m pip install --user semgrep
  else
    log_warn "Python is required before installing Semgrep"
    return 1
  fi
}
