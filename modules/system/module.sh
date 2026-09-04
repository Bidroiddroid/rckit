#!/usr/bin/env bash
AI_DEV_MODULE_NAME="system"
AI_DEV_MODULE_BINARY="bash"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  platform_is_supported
}

module_install() { module_verify "$1" || die "Unsupported operating system"; }
module_configure() { return 0; }
module_update() { module_verify "$1" || die "Unsupported operating system"; }
module_remove() { die "The system capability cannot be removed by rckit"; }

module_doctor() {
  platform_print
}
