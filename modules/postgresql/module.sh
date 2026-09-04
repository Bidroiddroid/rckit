#!/usr/bin/env bash
AI_DEV_MODULE_NAME="PostgreSQL"
AI_DEV_MODULE_BINARY="docker"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  service_verify postgresql
}
module_install() { service_install postgresql; }
module_configure() { return 0; }
module_update() { service_update postgresql; }
module_remove() { service_remove postgresql; }
module_doctor() { service_doctor postgresql; }
