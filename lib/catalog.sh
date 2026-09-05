#!/usr/bin/env bash

AI_DEV_COMPONENTS=()
AI_DEV_COMPONENT_CATEGORY=()
AI_DEV_COMPONENT_DEPS=()
AI_DEV_COMPONENT_MODULE=()
AI_DEV_COMPONENT_CREDENTIALS=()
AI_DEV_COMPONENT_CONTEXT_COST=()

catalog_load() {
  local manifest="$AI_DEV_ROOT/config/manifest.yaml"
  [[ -f "$manifest" ]] || die "Missing manifest: $manifest"
  AI_DEV_COMPONENTS=()
  AI_DEV_COMPONENT_CATEGORY=()
  AI_DEV_COMPONENT_DEPS=()
  AI_DEV_COMPONENT_MODULE=()
  AI_DEV_COMPONENT_CREDENTIALS=()
  AI_DEV_COMPONENT_CONTEXT_COST=()
  local line id category deps module credentials context_cost
  while IFS='|' read -r id category deps module credentials context_cost; do
    [[ -n "$id" ]] || continue
    AI_DEV_COMPONENTS+=("$id")
    AI_DEV_COMPONENT_CATEGORY+=("$category")
    AI_DEV_COMPONENT_DEPS+=("$deps")
    AI_DEV_COMPONENT_MODULE+=("$module")
    AI_DEV_COMPONENT_CREDENTIALS+=("$credentials")
    AI_DEV_COMPONENT_CONTEXT_COST+=("$context_cost")
    [[ -f "$AI_DEV_ROOT/$module/module.sh" ]] || die "Manifest component $id points to missing module: $module/module.sh"
  done < <(awk '
    /^  [a-zA-Z0-9_.-]+:$/ { id=$1; gsub(":","",id); category=""; deps=""; module=""; credentials="false" }
    /category:/ { category=$2 }
    /dependencies:/ { deps=$0; sub(/^.*dependencies:[ ]*/,"",deps); gsub("\\[|\\]|,"," ",deps) }
    /module:/ { module=$2 }
    /credentials:/ { credentials=$2 }
    /context_cost:/ { context_cost=$2; if (id != "") print id "|" category "|" deps "|" module "|" credentials "|" context_cost; id="" }
  ' "$manifest")
}

catalog_index_of() {
  local name="$1"
  local i
  for i in "${!AI_DEV_COMPONENTS[@]}"; do
    [[ "${AI_DEV_COMPONENTS[$i]}" == "$name" ]] && printf '%s\n' "$i" && return 0
  done
  return 1
}

catalog_component_exists() {
  catalog_index_of "$1" >/dev/null || die "Unknown component: $1"
}

catalog_all_components() {
  printf '%s\n' "${AI_DEV_COMPONENTS[@]}"
}

catalog_list() {
  local i
  printf 'Components:\n'
  for i in "${!AI_DEV_COMPONENTS[@]}"; do
    printf '  %-22s %s\n' "${AI_DEV_COMPONENTS[$i]}" "${AI_DEV_COMPONENT_CATEGORY[$i]}"
  done
}

catalog_deps_for() {
  local i
  i="$(catalog_index_of "$1")" || return 1
  for dep in ${AI_DEV_COMPONENT_DEPS[$i]}; do
    [[ -n "$dep" ]] && printf '%s\n' "$dep"
  done
}

catalog_module_for() {
  local i
  i="$(catalog_index_of "$1")" || return 1
  printf '%s\n' "${AI_DEV_COMPONENT_MODULE[$i]}"
}

catalog_category_for() {
  local i
  i="$(catalog_index_of "$1")" || return 1
  printf '%s\n' "${AI_DEV_COMPONENT_CATEGORY[$i]}"
}

catalog_credentials_for() {
  local i
  i="$(catalog_index_of "$1")" || return 1
  printf '%s\n' "${AI_DEV_COMPONENT_CREDENTIALS[$i]}"
}

catalog_context_cost_for() {
  local i
  i="$(catalog_index_of "$1")" || return 1
  printf '%s\n' "${AI_DEV_COMPONENT_CONTEXT_COST[$i]}"
}

catalog_profile_components() {
  local profile="$1"
  local profiles="$AI_DEV_ROOT/config/profiles.yaml"
  awk -v profile="$profile" '
    $0 ~ "^  " profile ":" { in_profile=1; next }
    in_profile && /^  [a-zA-Z0-9_.-]+:/ { exit }
    in_profile && /- / { print $2 }
  ' "$profiles"
}

catalog_resolve_visit() {
  local component="$1"
  local dep
  catalog_component_exists "$component"
  [[ " ${AI_DEV_SEEN[*]:-} " == *" $component "* ]] && return 0
  AI_DEV_SEEN+=("$component")
  while read -r dep; do
    [[ -n "$dep" ]] && catalog_resolve_visit "$dep"
  done < <(catalog_deps_for "$component")
  printf '%s\n' "$component"
}

catalog_resolve() {
  AI_DEV_SEEN=()
  local component
  for component in "$@"; do
    catalog_resolve_visit "$component"
  done | awk '!seen[$0]++'
}

plan_render() {
  local action="$1"
  shift || true
  printf 'AI DEV BOOTSTRAP PLAN\n'
  printf 'Action: %s\n' "$action"
  printf 'Dry run: %s\n' "${AI_DEV_DRY_RUN:-0}"
  printf 'Components:\n'
  local component
  for component in "$@"; do
    printf '  - %s (%s, credentials: %s, context: %s)\n' \
      "$component" \
      "$(catalog_category_for "$component")" \
      "$(catalog_credentials_for "$component")" \
      "$(catalog_context_cost_for "$component")"
    if [[ "$component" == "agent-skills" ]]; then
      printf '    source: https://github.com/vercel-labs/agent-skills (skills.sh CLI, project scope)\n'
    fi
  done
  if [[ "$action" == "remove" || "$action" == "reset" ]]; then
    printf 'Destructive guard: explicit confirmation required before deleting state, configuration, services, or data.\n'
  fi
}
