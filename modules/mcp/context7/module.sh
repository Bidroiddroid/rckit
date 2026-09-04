#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Context7 MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode && mcp_require_npx && mcp_config_fragment_exists context7
}

module_doctor() {
  mcp_doctor_common "$1"
  mcp_config_fragment_exists context7 && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
