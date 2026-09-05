#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Astro project generator"
AI_DEV_MODULE_BINARY="npm"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  local version major
  command_exists node && command_exists npm || return 1
  version="$(node -p 'process.versions.node')"
  major="${version%%.*}"
  version_at_least "$version" "22.12.0" && ((major % 2 == 0))
}

module_install() { module_verify "$1" || die "Astro requires Node.js 22.12.0+ from an even supported release; run ai-dev install node"; }
module_configure() { log_info "Astro is installed locally when ai-dev new <name> --stack astro is executed"; }
module_update() { module_install "$1"; }
module_remove() { log_info "Astro is project-local; no project files were removed"; }
module_doctor() { module_verify "$1" && printf '[OK] Astro project prerequisites are ready.\n' || printf '[WARN] Astro requires Node.js 22.12.0+ from an even release and npm.\n'; }
