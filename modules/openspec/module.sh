#!/usr/bin/env bash
AI_DEV_MODULE_NAME="OpenSpec"
AI_DEV_MODULE_BINARY="openspec"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() { require_command npm; run_cmd npm install -g @fission-ai/openspec@latest; }
module_verify() {
  command_exists openspec && command_exists node && version_at_least "$(node -p 'process.versions.node')" "20.19.0"
}
module_update() { run_cmd npm install -g @fission-ai/openspec@latest; }
module_remove() { confirm_destructive "remove OpenSpec CLI (project specifications are preserved)"; run_cmd npm uninstall -g @fission-ai/openspec; }

module_configure() {
  log_info "OpenSpec workflow templates are available in templates/openspec"
}

module_doctor() { module_verify "$1" && printf '[OK] OpenSpec and Node.js 20.19+ are available.\n' || printf '[WARN] OpenSpec requires Node.js 20.19+; run ai-dev install openspec.\n'; }
