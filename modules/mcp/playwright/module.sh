#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Playwright MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  mcp_install_config_only "$1"
}

module_configure() {
  mcp_configure_server playwright
}

module_verify() {
  mcp_verify_configured playwright && mcp_require_npx && mcp_require_node_major 20
}

module_doctor() {
  mcp_doctor_common "$1" "" playwright
  mcp_require_npx && printf '[OK] %s: npx found for local MCP server execution.\n' "$1" || printf '[WARN] %s: npx not found. Install/select node before enabling this MCP.\n' "$1"
  mcp_require_node_major 20 && printf '[OK] %s: Node.js is 20+.\n' "$1" || printf '[WARN] %s: Playwright MCP requires Node.js 20+.\n' "$1"
  mcp_config_fragment_exists playwright && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
