#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Python"
AI_DEV_MODULE_BINARY="python3"
AI_DEV_MODULE_APT_PACKAGES=(python3 python3-pip python3-venv)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists python3 && command_exists pip3
}

module_configure() {
  if command_exists pip3 && ! command_exists uv; then
    run_cmd python3 -m pip install --user uv
  fi
  if command_exists pip3 && ! command_exists ruff; then
    run_cmd python3 -m pip install --user ruff
  fi
}
