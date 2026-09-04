#!/usr/bin/env bash
AI_DEV_MODULE_NAME="GitHub MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  mcp_install_config_only "$1"
}

module_configure() {
  mcp_configure_server github
}

module_verify() {
  mcp_verify_configured github && mcp_require_env GITHUB_PERSONAL_ACCESS_TOKEN
}

module_doctor() {
  mcp_doctor_common "$1" GITHUB_PERSONAL_ACCESS_TOKEN github
  mcp_config_fragment_exists github && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
