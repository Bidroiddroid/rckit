#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Semgrep"
AI_DEV_MODULE_BINARY="semgrep"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  require_command uv
  run_cmd uv tool install semgrep
}
module_update() { run_cmd uv tool upgrade semgrep; }
module_remove() { confirm_destructive "remove Semgrep tool environment"; run_cmd uv tool uninstall semgrep; }
