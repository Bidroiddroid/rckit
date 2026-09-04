#!/usr/bin/env bash
AI_DEV_MODULE_NAME="GitHub MCP"
AI_DEV_MODULE_BINARY="opencode"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  mcp_require_opencode && command_exists docker && mcp_config_fragment_exists github
}

module_doctor() {
  if mcp_require_opencode; then
    printf '[OK] %s: OpenCode command found.\n' "$1"
  else
    printf '[WARN] %s: OpenCode command not found. Install/select opencode first.\n' "$1"
  fi
  command_exists docker && printf '[OK] %s: Docker found for GitHub MCP container mode.\n' "$1" || printf '[WARN] %s: Docker is required for the configured GitHub MCP mode.\n' "$1"
  mcp_require_env GITHUB_PERSONAL_ACCESS_TOKEN && printf '[OK] %s: GITHUB_PERSONAL_ACCESS_TOKEN is present.\n' "$1" || printf '[WARN] %s: GITHUB_PERSONAL_ACCESS_TOKEN is missing. Keep it outside Git-tracked files.\n' "$1"
  mcp_config_fragment_exists github && printf '[OK] %s: config fragment exists.\n' "$1" || printf '[WARN] %s: config fragment missing.\n' "$1"
}
