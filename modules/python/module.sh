#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Python"
AI_DEV_MODULE_BINARY="python3"
AI_DEV_MODULE_APT_PACKAGES=(python3 python3-pip python3-venv)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists python3 && command_exists pip3
}

module_configure() {
  command_exists uv || download_and_run https://astral.sh/uv/install.sh
  command_exists ruff || run_cmd uv tool install ruff
}

module_verify() { command_exists python3 && command_exists pip3 && command_exists uv && command_exists ruff; }
module_update() { run_cmd sudo apt-get update; run_cmd sudo apt-get install -y --only-upgrade "${AI_DEV_MODULE_APT_PACKAGES[@]}"; run_cmd uv self update; run_cmd uv tool upgrade ruff; }
module_remove() { confirm_destructive "remove Python host packages (uv tools are preserved)"; run_cmd sudo apt-get remove -y "${AI_DEV_MODULE_APT_PACKAGES[@]}"; }
