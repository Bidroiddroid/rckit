#!/usr/bin/env bash

security_is_git_tracked() {
  git -C "$AI_DEV_ROOT" ls-files --error-unmatch "$1" >/dev/null 2>&1
}

security_write_example_file() {
  local path="$1"
  shift
  if [[ "$path" != *.example && "$(basename "$path")" != ".env.example" ]]; then
    die "Refusing to write possible secret file without example suffix: $path"
  fi
  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$@" >"$path"
}

security_refuse_secret_value() {
  local value="$1"
  [[ "$value" != *"TOKEN="* && "$value" != *"PASSWORD="* && "$value" != *"SECRET="* ]] || die "Refusing to write secret-like value"
}
