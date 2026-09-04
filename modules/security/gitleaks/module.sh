#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Gitleaks"
AI_DEV_MODULE_BINARY="gitleaks"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() { require_command mise; run_cmd mise use --global github:gitleaks/gitleaks; }
module_update() { module_install "$1"; }
module_remove() { confirm_destructive "remove mise-managed Gitleaks"; run_cmd mise unuse --global github:gitleaks/gitleaks; }
