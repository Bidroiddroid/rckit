#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Traefik"
AI_DEV_MODULE_BINARY="docker"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  service_verify traefik
}
module_install() { service_install traefik; }
module_configure() { return 0; }
module_update() { service_update traefik; }
module_remove() { service_remove traefik; }
module_doctor() { service_doctor traefik; }
