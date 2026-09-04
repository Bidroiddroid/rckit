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
    project_name="$(basename "$name")"
  fi
  if [[ -e "$target" ]]; then
    confirm "Project path exists. Write missing files into $target?" || die "Project creation cancelled"
  fi
  mkdir -p "$target/docs" "$target/tests" "$target/openspec/changes" "$target/openspec/specs" "$target/.opencode/skills"
  scaffold_write "$target/AGENTS.md" "$AI_DEV_ROOT/templates/project/base/AGENTS.md" "$project_name"
  scaffold_write "$target/README.md" "$AI_DEV_ROOT/templates/project/base/README.md" "$project_name"
  scaffold_write "$target/.env.example" "$AI_DEV_ROOT/templates/project/base/env.example" "$project_name"
  scaffold_write "$target/.gitignore" "$AI_DEV_ROOT/templates/project/base/gitignore" "$project_name"
  scaffold_write "$target/docker-compose.yml" "$AI_DEV_ROOT/templates/project/$stack/docker-compose.yml" "$project_name"
  scaffold_migrate_opencode_config "$target"
  scaffold_write "$target/opencode.json" "$AI_DEV_ROOT/templates/opencode/opencode.json" "$project_name"
  scaffold_write "$target/openspec/config.yaml" "$AI_DEV_ROOT/templates/openspec/config.yaml" "$project_name"
  scaffold_copy_tree "$target/.opencode/skills" "$AI_DEV_ROOT/skills" "$project_name"
  scaffold_copy_openspec_skills "$target/.opencode/skills"
  scaffold_copy_tree "$target/openspec" "$AI_DEV_ROOT/templates/openspec" "$project_name"
  log_info "Created project scaffold: $target ($stack, project: $project_name)"
}

scaffold_migrate_opencode_config() {
  local target="$1" legacy="$target/.opencode/opencode.json"
  [[ -f "$legacy" || -f "$target/opencode.json" ]] || return 0
  if [[ -f "$legacy" && ! -f "$target/opencode.json" ]]; then
    cp "$legacy" "$target/opencode.json"
    log_warn "Migrated legacy OpenCode project config to $target/opencode.json; preserved $legacy"
  fi
}

scaffold_copy_openspec_skills() {
  local dest="$1" src="$AI_DEV_ROOT/.codex/skills" skill name
  [[ -d "$src" ]] || return 0
  for skill in "$src"/openspec-*; do
    [[ -d "$skill" ]] || continue
    name="$(basename "$skill")"
    scaffold_copy_tree "$dest/$name" "$skill" ""
  done
}

scaffold_should_refresh() {
  local dest="$1"
  case "$dest" in
    */openspec/config.yaml)
      grep -q "schema: spec-driven" "$dest" && grep -q "Conhecimento caro" "$dest" && return 1
      return 0
      ;;
    */opencode.json|*/.opencode/opencode.json)
      python3 -m json.tool "$dest" >/dev/null 2>&1 && grep -q '"agent"' "$dest" && grep -q '"mcp"' "$dest" && return 1
      return 0
      ;;
  esac
  return 1
}

scaffold_write() {
  local dest="$1" src="$2" project_name="$3"
  local replacement
  [[ -f "$src" ]] || die "Missing template: $src"
  if [[ -e "$dest" ]]; then
    if scaffold_should_refresh "$dest"; then
      local backup
      backup="$dest.old.$(date +%Y%m%d%H%M%S)"
      mv "$dest" "$backup"
      log_warn "Backed up incomplete config: $backup"
    else
      log_warn "Skipping existing file: $dest"
      return 0
    fi
  fi
  mkdir -p "$(dirname "$dest")"
  replacement="${project_name//\\/\\\\}"
  replacement="${replacement//&/\\&}"
  replacement="${replacement//|/\\|}"
  sed "s|{{PROJECT_NAME}}|$replacement|g" "$src" >"$dest"
}

scaffold_copy_tree() {
  local dest_dir="$1" src_dir="$2" project_name="$3"
  local src rel dest
  [[ -d "$src_dir" ]] || return 0
  while IFS= read -r src; do
    rel="${src#"$src_dir"/}"
    [[ "$rel" == "config.yaml" ]] && continue
    dest="$dest_dir/$rel"
    scaffold_write "$dest" "$src" "$project_name"
  done < <(find "$src_dir" -type f | sort)
}
