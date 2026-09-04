#!/usr/bin/env bash

mcp_require_opencode() {
  if command_exists opencode; then
    return 0
  fi
  return 1
}

mcp_require_npx() {
  command_exists npx
}

mcp_require_node_major() {
  local expected="$1"
  command_exists node || return 1
  local version major
  version="$(node -v 2>/dev/null | sed 's/^v//')"
  major="${version%%.*}"
  [[ "$major" =~ ^[0-9]+$ ]] && [[ "$major" -ge "$expected" ]]
}

mcp_require_chrome() {
  command_exists google-chrome || command_exists chromium || command_exists chromium-browser
}

mcp_require_env() {
  local name="$1"
  [[ -n "${!name:-}" ]]
}

mcp_doctor_common() {
  local component="$1"
  local env_name="${2:-}"
  local mcp_name="${3:-}"
  if mcp_require_opencode; then
    printf '[OK] %s: OpenCode command found.\n' "$component"
  else
    printf '[WARN] %s: OpenCode command not found. Install/select opencode before enabling this MCP.\n' "$component"
  fi
  command_exists python3 && printf '[OK] %s: python3 found for config merge.\n' "$component" || printf '[WARN] %s: python3 not found; config merge cannot run safely.\n' "$component"
  if [[ -n "$mcp_name" ]]; then
    if mcp_server_configured "$mcp_name"; then
      printf '[OK] %s: MCP server is configured in %s.\n' "$component" "$(mcp_config_path)"
    else
      printf '[WARN] %s: MCP server is not configured in %s.\n' "$component" "$(mcp_config_path)"
    fi
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

mcp_config_path() {
  printf '%s/.config/opencode/opencode.json\n' "$HOME"
}

mcp_server_configured() {
  local name="$1"
  local config
  config="$(mcp_config_path)"
  [[ -f "$config" ]] || return 1
  python3 - "$config" "$name" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as fh:
    data = json.load(fh)
sys.exit(0 if sys.argv[2] in data.get("mcp", {}) else 1)
PY
}

mcp_configure_server() {
  local name="$1"
  local fragment
  local config
  fragment="$(mcp_config_fragment_dir)/$name.json"
  config="$(mcp_config_path)"
  [[ -f "$fragment" ]] || die "Missing MCP config fragment: $fragment"
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    log_info "Dry-run would merge $name MCP into $config"
    return 0
  fi
  command_exists python3 || die "python3 is required to safely merge OpenCode MCP JSON config"
  mkdir -p "$(dirname "$config")"
  if [[ ! -f "$config" ]]; then
    cp "$AI_DEV_ROOT/templates/opencode/opencode.json" "$config"
  fi
  local tmp
  tmp="$(mktemp)"
  python3 - "$config" "$fragment" "$name" >"$tmp" <<'PY'
import json
import sys

config_path, fragment_path, name = sys.argv[1:4]
with open(config_path, "r", encoding="utf-8") as fh:
    config = json.load(fh)
with open(fragment_path, "r", encoding="utf-8") as fh:
    server = json.load(fh)
config.setdefault("mcp", {})
config["mcp"][name] = server
json.dump(config, sys.stdout, indent=2, ensure_ascii=False)
sys.stdout.write("\n")
PY
  mv "$tmp" "$config"
  log_info "Configured OpenCode MCP server: $name"
}

mcp_verify_configured() {
  local name="$1"
  mcp_require_opencode && command_exists python3 && mcp_server_configured "$name"
}

mcp_install_config_only() {
  log_info "$1 uses OpenCode MCP configuration; no separate package install is required."
}

mcp_update_server() {
  mcp_configure_server "$1"
}

mcp_remove_server() {
  local name="$1" config tmp
  config="$(mcp_config_path)"
  [[ -f "$config" ]] || return 0
  confirm_destructive "remove $name MCP configuration (credentials are untouched)"
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    log_info "Dry-run would remove $name from $config"
    return 0
  fi
  tmp="$(mktemp)"
  python3 - "$config" "$name" >"$tmp" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as fh:
    config = json.load(fh)
config.setdefault("mcp", {}).pop(sys.argv[2], None)
json.dump(config, sys.stdout, indent=2, ensure_ascii=False)
sys.stdout.write("\n")
PY
  mv "$tmp" "$config"
}
