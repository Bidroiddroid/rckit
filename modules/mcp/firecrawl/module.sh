#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Firecrawl MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode && mcp_require_npx && mcp_require_env FIRECRAWL_API_KEY && mcp_config_fragment_exists firecrawl
}

module_doctor() {
  mcp_doctor_common "$1" FIRECRAWL_API_KEY
  mcp_config_fragment_exists firecrawl && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
