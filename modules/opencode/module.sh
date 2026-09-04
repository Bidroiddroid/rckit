#!/usr/bin/env bash
AI_DEV_MODULE_NAME="OpenCode"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode
}

module_configure() {
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    log_info "Dry-run skipped OpenCode config write"
    return 0
  fi
  mkdir -p "$HOME/.config/opencode"
  if [[ -f "$HOME/.config/opencode/opencode.json" ]]; then
    log_warn "OpenCode config exists; not overwriting $HOME/.config/opencode/opencode.json"
  else
    cp "$AI_DEV_ROOT/templates/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
    log_info "OpenCode configuration written with conservative approval defaults"
  fi
}
