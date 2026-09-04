#!/usr/bin/env bash
AI_DEV_MODULE_NAME="system"
AI_DEV_MODULE_BINARY="bash"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  platform_is_supported
}

module_doctor() {
  platform_print
}
