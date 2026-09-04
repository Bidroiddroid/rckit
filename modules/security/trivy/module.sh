#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Trivy"
AI_DEV_MODULE_BINARY="trivy"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() { require_command mise; run_cmd mise use --global github:aquasecurity/trivy; }
module_update() { module_install "$1"; }
module_remove() { confirm_destructive "remove mise-managed Trivy"; run_cmd mise unuse --global github:aquasecurity/trivy; }
