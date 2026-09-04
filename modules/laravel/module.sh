#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Laravel"
AI_DEV_MODULE_BINARY="laravel"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() { require_command composer; run_cmd composer global require laravel/installer; }
module_update() { run_cmd composer global update laravel/installer; }
module_remove() { confirm_destructive "remove Laravel installer"; run_cmd composer global remove laravel/installer; }
module_doctor() { module_verify "$1" && printf '[OK] Laravel installer is available.\n' || printf '[WARN] Laravel installer is missing or Composer global bin is not in PATH.\n'; }
