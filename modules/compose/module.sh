#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Docker Compose"
AI_DEV_MODULE_BINARY="docker"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists docker && docker compose version >/dev/null 2>&1
}

module_install() {
  platform_detect
  [[ "$AI_DEV_PACKAGE_MANAGER" == "apt" ]] || die "Docker Compose installation requires apt on supported platforms"
  run_cmd sudo apt-get update
  if apt-cache show docker-compose-plugin >/dev/null 2>&1; then
    run_cmd sudo apt-get install -y docker-compose-plugin
  elif apt-cache show docker-compose-v2 >/dev/null 2>&1; then
    run_cmd sudo apt-get install -y docker-compose-v2
  else
    run_cmd sudo apt-get install -y docker-compose
  fi
}
module_update() { module_install "$1"; }
module_remove() { die "Remove Docker Compose with the package manager that installed it; Docker data was not changed"; }
