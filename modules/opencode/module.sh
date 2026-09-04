#!/usr/bin/env bash
AI_DEV_MODULE_NAME="OpenCode"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() { require_command npm; run_cmd npm install -g opencode-ai; }
module_update() { run_cmd npm install -g opencode-ai@latest; }
module_remove() { confirm_destructive "remove OpenCode CLI (configuration is preserved)"; run_cmd npm uninstall -g opencode-ai; }

module_verify() {
  mcp_require_opencode
}

module_doctor() {
  mcp_require_opencode && printf '[OK] OpenCode stable CLI is available.\n' || printf '[WARN] OpenCode stable CLI is missing.\n'
  [[ -f "$HOME/.config/opencode/opencode.json" ]] && python3 -m json.tool "$HOME/.config/opencode/opencode.json" >/dev/null 2>&1 && printf '[OK] OpenCode configuration is valid JSON.\n' || printf '[WARN] OpenCode configuration is missing or invalid.\n'
  printf '[INFO] Connect a model provider from OpenCode with /connect.\n'
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
