#!/usr/bin/env bash
AI_DEV_MODULE_NAME="mise"
AI_DEV_MODULE_BINARY="mise"
source "$AI_DEV_ROOT/lib/module-default.sh"

module_install() {
  download_and_run https://mise.run
}

module_update() {
  run_cmd mise self-update
}

module_remove() {
  confirm_destructive "remove mise binary (installed tools are preserved)"
  run_cmd rm -f "$HOME/.local/bin/mise"
}

module_doctor() {
  if command_exists mise; then
    mise doctor || true
  elif [[ -x "$HOME/.local/bin/mise" ]]; then
    printf '[WARN] mise exists in ~/.local/bin but that directory is not in PATH.\n'
  else
    printf '[WARN] mise is not installed.\n'
  fi
}
