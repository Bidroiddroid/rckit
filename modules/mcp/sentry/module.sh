#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Sentry MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  mcp_install_config_only "$1"
}

module_configure() {
  mcp_configure_server sentry
}

module_verify() {
  mcp_verify_configured sentry
}
module_update() { mcp_update_server sentry; }
module_remove() { mcp_remove_server sentry; }

module_doctor() {
  mcp_doctor_common "$1" "" sentry
  printf '[WARN] %s: first use may require OpenCode OAuth authorization for Sentry.\n' "$1"
  mcp_config_fragment_exists sentry && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
