#!/usr/bin/env bash
AI_DEV_MODULE_NAME="fd"
AI_DEV_MODULE_BINARY="fdfind"
AI_DEV_MODULE_APT_PACKAGES=(fd-find)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists fd || command_exists fdfind
}
