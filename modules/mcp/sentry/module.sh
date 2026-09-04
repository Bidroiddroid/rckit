#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Sentry MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode && mcp_require_npx && mcp_require_env SENTRY_AUTH_TOKEN && mcp_config_fragment_exists sentry
}

module_doctor() {
  mcp_doctor_common "$1" SENTRY_AUTH_TOKEN
  mcp_config_fragment_exists sentry && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
