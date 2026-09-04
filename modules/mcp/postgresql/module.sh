#!/usr/bin/env bash
AI_DEV_MODULE_NAME="PostgreSQL MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode && mcp_require_npx && mcp_require_env DATABASE_URL && mcp_config_fragment_exists postgresql
}

module_doctor() {
  mcp_doctor_common "$1" DATABASE_URL
  mcp_config_fragment_exists postgresql && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
