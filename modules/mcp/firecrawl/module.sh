#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Firecrawl MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  mcp_install_config_only "$1"
}

module_configure() {
  mcp_configure_server firecrawl
}

module_verify() {
  mcp_verify_configured firecrawl && mcp_require_npx && mcp_require_env FIRECRAWL_API_KEY
}

module_doctor() {
  mcp_doctor_common "$1" FIRECRAWL_API_KEY firecrawl
  mcp_require_npx && printf '[OK] %s: npx found for local MCP server execution.\n' "$1" || printf '[WARN] %s: npx not found. Install/select node before enabling this MCP.\n' "$1"
  mcp_config_fragment_exists firecrawl && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
