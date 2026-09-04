#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Chrome DevTools MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  mcp_install_config_only "$1"
}

module_configure() {
  mcp_configure_server chrome-devtools
}

module_verify() {
  mcp_verify_configured chrome-devtools && mcp_require_npx && mcp_require_chrome
}
module_update() { mcp_update_server chrome-devtools; }
module_remove() { mcp_remove_server chrome-devtools; }

module_doctor() {
  mcp_doctor_common "$1" "" chrome-devtools
  mcp_require_npx && printf '[OK] %s: npx found for local MCP server execution.\n' "$1" || printf '[WARN] %s: npx not found. Install/select node before enabling this MCP.\n' "$1"
  mcp_require_chrome && printf '[OK] %s: Chrome/Chromium browser found.\n' "$1" || printf '[WARN] %s: Chrome DevTools MCP requires Google Chrome or Chromium.\n' "$1"
  printf '[WARN] %s: browser content can be exposed to the agent; keep this MCP disabled unless needed.\n' "$1"
  mcp_config_fragment_exists chrome-devtools && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
