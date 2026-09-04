#!/usr/bin/env bash
AI_DEV_MODULE_NAME="PHP"
AI_DEV_MODULE_BINARY="php"
AI_DEV_MODULE_APT_PACKAGES=(php php-cli php-mbstring php-xml php-curl php-zip unzip composer)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists php && command_exists composer
}
