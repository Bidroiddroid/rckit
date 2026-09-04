#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Docker"
AI_DEV_MODULE_BINARY="docker"
AI_DEV_MODULE_APT_PACKAGES=(docker.io)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists docker && docker info >/dev/null 2>&1
}

module_doctor() {
  if ! command_exists docker; then
    printf '[WARN] Docker CLI is not installed.\n'
  elif ! docker info >/dev/null 2>&1; then
    printf '[WARN] Docker is installed but the daemon is not reachable. Start Docker or check user group permissions.\n'
  else
    printf '[OK] Docker daemon is reachable.\n'
  fi
}
