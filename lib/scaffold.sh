#!/usr/bin/env bash

scaffold_new() {
  local name="" stack="node" target="" project_name=""
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
  if [[ "$name" == "." ]]; then
    target="."
    project_name="$(basename "$PWD")"
  else
    target="$name"
    project_name="$name"
  fi
  if [[ -e "$target" ]]; then
    confirm "Project path exists. Write missing files into $target?" || die "Project creation cancelled"
  fi
  mkdir -p "$target/docs" "$target/tests" "$target/openspec" "$target/.opencode/skills"
  scaffold_write "$target/AGENTS.md" "$AI_DEV_ROOT/templates/project/base/AGENTS.md" "$project_name"
  scaffold_write "$target/README.md" "$AI_DEV_ROOT/templates/project/base/README.md" "$project_name"
  scaffold_write "$target/.env.example" "$AI_DEV_ROOT/templates/project/base/env.example" "$project_name"
  scaffold_write "$target/.gitignore" "$AI_DEV_ROOT/templates/project/base/gitignore" "$project_name"
  scaffold_write "$target/docker-compose.yml" "$AI_DEV_ROOT/templates/project/$stack/docker-compose.yml" "$project_name"
  scaffold_write "$target/.opencode/opencode.json" "$AI_DEV_ROOT/templates/opencode/opencode.json" "$project_name"
  scaffold_write "$target/openspec/config.yaml" "$AI_DEV_ROOT/templates/openspec/config.yaml" "$project_name"
  log_info "Created project scaffold: $target ($stack, project: $project_name)"
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
