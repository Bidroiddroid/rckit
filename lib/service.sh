#!/usr/bin/env bash

service_config_root() {
  printf '%s/.config/rckit/services\n' "$HOME"
}

service_template_path() {
  printf '%s/templates/services/%s.compose.yml\n' "$AI_DEV_ROOT" "$1"
}

service_config_path() {
  printf '%s/%s/compose.yml\n' "$(service_config_root)" "$1"
}

service_install() {
  local name="$1" src dest
  src="$(service_template_path "$name")"
  dest="$(service_config_path "$name")"
  [[ -f "$src" ]] || die "Missing service template: $src"
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    log_info "Dry-run would create $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]]; then
    log_info "$name service configuration already exists; preserving $dest"
  else
    cp "$src" "$dest"
    log_info "Created $name service configuration: $dest"
  fi
}

service_verify() {
  local name="$1" dest
  dest="$(service_config_path "$name")"
  command_exists docker && docker compose version >/dev/null 2>&1 && [[ -f "$dest" ]] && docker compose -f "$dest" config -q >/dev/null 2>&1
}

service_update() {
  local name="$1" src dest backup
  src="$(service_template_path "$name")"
  dest="$(service_config_path "$name")"
  if [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]]; then
    log_info "Dry-run would refresh $dest after creating a backup"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]] && ! cmp -s "$src" "$dest"; then
    backup="$dest.old.$(date +%Y%m%d%H%M%S)"
    cp "$dest" "$backup"
    log_warn "Backed up service configuration: $backup"
  fi
  cp "$src" "$dest"
}

service_remove() {
  local name="$1" dest
  dest="$(service_config_path "$name")"
  confirm_destructive "remove $name service configuration (containers and volumes are preserved)"
  run_cmd rm -f "$dest"
}

service_doctor() {
  local name="$1" dest
  dest="$(service_config_path "$name")"
  [[ -f "$dest" ]] && printf '[OK] %s service configuration exists at %s.\n' "$name" "$dest" || printf '[WARN] %s service configuration is missing.\n' "$name"
  command_exists docker && docker compose version >/dev/null 2>&1 && printf '[OK] Docker Compose is available.\n' || printf '[WARN] Docker Compose is unavailable.\n'
  printf '[INFO] Start explicitly with: docker compose -f %s up -d\n' "$dest"
}
