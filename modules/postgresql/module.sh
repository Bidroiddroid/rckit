#!/usr/bin/env bash
AI_DEV_MODULE_NAME="PostgreSQL"
AI_DEV_MODULE_BINARY="docker"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists docker
}
