#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Docker Compose"
AI_DEV_MODULE_BINARY="docker"
AI_DEV_MODULE_APT_PACKAGES=(docker-compose-plugin)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists docker && docker compose version >/dev/null 2>&1
}
