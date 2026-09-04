#!/usr/bin/env bash
AI_DEV_MODULE_NAME="MySQL"
AI_DEV_MODULE_BINARY="docker"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  service_verify mysql
}
module_install() { service_install mysql; }
module_configure() { return 0; }
module_update() { service_update mysql; }
module_remove() { service_remove mysql; }
module_doctor() { service_doctor mysql; }
