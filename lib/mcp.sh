#!/usr/bin/env bash

mcp_require_opencode() {
  if command_exists opencode || command_exists opencode2; then
    return 0
  fi
  return 1
}

mcp_require_npx() {
  command_exists npx
}

mcp_require_env() {
  local name="$1"
  [[ -n "${!name:-}" ]]
}

mcp_doctor_common() {
  local component="$1"
  local env_name="${2:-}"
  if mcp_require_opencode; then
    printf '[OK] %s: OpenCode command found.\n' "$component"
  else
    printf '[WARN] %s: OpenCode command not found. Install/select opencode before enabling this MCP.\n' "$component"
  fi
  if mcp_require_npx; then
    printf '[OK] %s: npx found for local MCP server execution.\n' "$component"
  else
    printf '[WARN] %s: npx not found. Install/select node before enabling this MCP.\n' "$component"
  fi
  if [[ -n "$env_name" ]]; then
    if mcp_require_env "$env_name"; then
      printf '[OK] %s: required environment variable %s is present.\n' "$component" "$env_name"
    else
      printf '[WARN] %s: required environment variable %s is missing. Configure it outside Git-tracked files.\n' "$component" "$env_name"
    fi
  fi
}

mcp_config_fragment_dir() {
  printf '%s/templates/opencode/mcp\n' "$AI_DEV_ROOT"
}

mcp_config_fragment_exists() {
  local name="$1"
  [[ -f "$(mcp_config_fragment_dir)/$name.json" ]]
}
