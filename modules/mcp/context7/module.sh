#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Context7 MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  mcp_install_config_only "$1"
}

module_configure() {
  mcp_configure_server context7
}

module_verify() {
  mcp_verify_configured context7
}

module_doctor() {
  mcp_doctor_common "$1" "" context7
  mcp_config_fragment_exists context7 && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
