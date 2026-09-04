#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Node.js"
AI_DEV_MODULE_BINARY="node"
AI_DEV_MODULE_APT_PACKAGES=(nodejs npm)
source "$AI_DEV_ROOT/lib/module-default.sh"

module_verify() {
  command_exists node && command_exists npm
}

module_configure() {
  if command_exists npm && ! command_exists pnpm; then
    run_cmd npm install -g pnpm
  fi
  if command_exists npm && ! command_exists tsc; then
    run_cmd npm install -g typescript
  fi
}
