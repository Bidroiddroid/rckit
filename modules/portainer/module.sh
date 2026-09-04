#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Portainer"
AI_DEV_MODULE_BINARY="docker"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  service_verify portainer
}
module_install() { service_install portainer; }
module_configure() { return 0; }
module_update() { service_update portainer; }
module_remove() { service_remove portainer; }
module_doctor() { service_doctor portainer; }
