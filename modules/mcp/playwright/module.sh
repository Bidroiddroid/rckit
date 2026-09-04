#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Playwright MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode && mcp_require_npx && mcp_config_fragment_exists playwright
}

module_doctor() {
  mcp_doctor_common "$1"
  if command_exists node; then
    local major
    major="$(node -v | sed 's/^v//' | cut -d. -f1)"
    [[ "$major" -ge 20 ]] && printf '[OK] %s: Node.js is 20+.\n' "$1" || printf '[WARN] %s: Playwright MCP requires Node.js 20+.\n' "$1"
  fi
  mcp_config_fragment_exists playwright && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
