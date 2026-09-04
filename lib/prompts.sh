#!/usr/bin/env bash

confirm() {
  local message="$1"
  if [[ "${AI_DEV_YES:-0}" == "1" ]]; then
    log_info "$message: yes"
    return 0
  fi
  printf '%s [y/N] ' "$message"
  local answer
  read -r answer || return 1
  [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "YES" ]]
}

confirm_plan() {
  local action="$1"
  if ! confirm "Proceed with $action plan?"; then
    log_warn "Cancelled $action plan"
    exit 0
  fi
}

confirm_destructive() {
  local target="$1"
  confirm "This may be destructive: $target. Continue?" || die "Destructive action cancelled: $target"
}

prompt_select_components() {
  if [[ ! -t 0 && "${AI_DEV_ALLOW_STDIN_PROMPT:-0}" != "1" ]]; then
    die "No interactive terminal available. Pass components explicitly or use --profile."
  fi
  local -a selected=()
  local i line token index selected_count mark component
  for i in "${!AI_DEV_COMPONENTS[@]}"; do
    selected[$i]=0
  done

  while true; do
    printf '\nSelect components:\n' >&2
    for i in "${!AI_DEV_COMPONENTS[@]}"; do
      mark=" "
      [[ "${selected[$i]}" == "1" ]] && mark="x"
      printf '  [%s] %2d. %-22s %s\n' "$mark" "$((i + 1))" "${AI_DEV_COMPONENTS[$i]}" "${AI_DEV_COMPONENT_CATEGORY[$i]}" >&2
    done
    printf '\nType numbers to toggle, "a" all, "n" none, "d" done, "q" quit: ' >&2
    read -r line || die "Component selection cancelled"
    line="${line//,/ }"
    case "$line" in
      q|quit|cancel)
        die "Component selection cancelled"
        ;;
      a|all)
        for i in "${!selected[@]}"; do selected[$i]=1; done
        continue
        ;;
      n|none|clear)
        for i in "${!selected[@]}"; do selected[$i]=0; done
        continue
        ;;
      d|done|"")
        selected_count=0
        for i in "${!selected[@]}"; do
          [[ "${selected[$i]}" == "1" ]] && selected_count=$((selected_count + 1))
        done
        [[ "$selected_count" -gt 0 ]] || die "No components selected."
        for i in "${!selected[@]}"; do
          if [[ "${selected[$i]}" == "1" ]]; then
            printf '%s\n' "${AI_DEV_COMPONENTS[$i]}"
          fi
        done
        return 0
        ;;
    esac

    for token in $line; do
      if [[ "$token" =~ ^[0-9]+$ ]]; then
        index=$((token - 1))
        if [[ "$index" -ge 0 && "$index" -lt "${#AI_DEV_COMPONENTS[@]}" ]]; then
          [[ "${selected[$index]}" == "1" ]] && selected[$index]=0 || selected[$index]=1
        else
          log_warn "Ignoring invalid selection number: $token"
        fi
      else
        component="$token"
        if index="$(catalog_index_of "$component" 2>/dev/null)"; then
          [[ "${selected[$index]}" == "1" ]] && selected[$index]=0 || selected[$index]=1
        else
          log_warn "Ignoring unknown component: $component"
        fi
      fi
    done
  done
}
