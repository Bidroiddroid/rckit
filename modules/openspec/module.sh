#!/usr/bin/env bash
AI_DEV_MODULE_NAME="OpenSpec"
AI_DEV_MODULE_BINARY="openspec"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_configure() {
  log_info "OpenSpec workflow templates are available in templates/openspec"
}
