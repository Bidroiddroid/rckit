#!/usr/bin/env bash

scaffold_new() {
  local name="" stack="node"
  while (($#)); do
    case "$1" in
      --stack)
        shift
        stack="${1:-}"
        ;;
      --stack=*)
        stack="${1#--stack=}"
        ;;
      --yes|-y)
        export AI_DEV_YES=1
        ;;
      --help|-h)
        printf 'Usage: ai-dev new <name> [--stack node|python|laravel]\n'
        return 0
        ;;
      *)
        [[ -z "$name" ]] || die "Unexpected argument: $1"
        name="$1"
        ;;
    esac
    shift || true
  done
  [[ -n "$name" ]] || die "new requires a project name"
  [[ "$stack" == "node" || "$stack" == "python" || "$stack" == "laravel" ]] || die "Unsupported stack: $stack"
  if [[ -e "$name" ]]; then
    confirm "Project path exists. Write missing files into $name?" || die "Project creation cancelled"
  fi
  mkdir -p "$name/docs" "$name/tests" "$name/openspec" "$name/.opencode/skills"
  scaffold_write "$name/AGENTS.md" "$AI_DEV_ROOT/templates/project/base/AGENTS.md" "$name"
  scaffold_write "$name/README.md" "$AI_DEV_ROOT/templates/project/base/README.md" "$name"
  scaffold_write "$name/.env.example" "$AI_DEV_ROOT/templates/project/base/env.example" "$name"
  scaffold_write "$name/.gitignore" "$AI_DEV_ROOT/templates/project/base/gitignore" "$name"
  scaffold_write "$name/docker-compose.yml" "$AI_DEV_ROOT/templates/project/$stack/docker-compose.yml" "$name"
  scaffold_write "$name/.opencode/opencode.json" "$AI_DEV_ROOT/templates/opencode/opencode.json" "$name"
  scaffold_write "$name/openspec/config.yaml" "$AI_DEV_ROOT/templates/openspec/config.yaml" "$name"
  log_info "Created project scaffold: $name ($stack)"
}

scaffold_write() {
  local dest="$1" src="$2" project_name="$3"
  [[ -f "$src" ]] || die "Missing template: $src"
  if [[ -e "$dest" ]]; then
    log_warn "Skipping existing file: $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  sed "s/{{PROJECT_NAME}}/$project_name/g" "$src" >"$dest"
}
