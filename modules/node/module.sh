#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Node.js"
AI_DEV_MODULE_BINARY="node"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists node && command_exists npm && command_exists pnpm && command_exists tsc && version_at_least "$(node -p 'process.versions.node')" "20.19.0"
}

module_install() {
  require_command mise
  run_cmd mise use --global node@22
}

module_configure() {
  command_exists corepack && run_cmd corepack enable || true
  if command_exists npm && ! command_exists pnpm; then run_cmd npm install -g pnpm; fi
  if command_exists npm && ! command_exists tsc; then
    run_cmd npm install -g typescript
  fi
}

module_update() { run_cmd mise use --global node@22; module_configure "$1"; }
module_remove() { confirm_destructive "remove mise-managed Node.js 22"; run_cmd mise uninstall node@22; }
module_doctor() {
  command_exists node && printf '[INFO] Node.js %s\n' "$(node --version)" || printf '[WARN] Node.js is missing.\n'
  module_verify "$1" && printf '[OK] Node.js 20.19+, npm, pnpm and TypeScript are ready.\n' || printf '[WARN] Node.js toolchain is incomplete; run ai-dev install node.\n'
}
