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

  if [[ -t 0 && -t 1 ]] && command_exists whiptail; then
    prompt_select_components_whiptail
    return 0
  fi

  if [[ -t 0 && -t 1 ]]; then
    prompt_select_components_keyboard
    return 0
  fi

  prompt_select_components_numbered
}

prompt_select_components_whiptail() {
  local -a items=()
  local i choices
  for i in "${!AI_DEV_COMPONENTS[@]}"; do
    items+=("${AI_DEV_COMPONENTS[$i]}" "${AI_DEV_COMPONENT_CATEGORY[$i]}" "OFF")
  done

  if ! choices="$(whiptail \
    --title "AI DEV BOOTSTRAP" \
    --separate-output \
    --checklist "Use Space to mark [x], arrows to move, Enter to continue." \
    24 78 16 \
    "${items[@]}" \
    3>&1 1>&2 2>&3)"; then
    die "Component selection cancelled"
  fi

  [[ -n "$choices" ]] || die "No components selected."
  printf '%s\n' "$choices"
}

prompt_draw_keyboard_menu() {
  local cursor="$1"
  shift
  local -a selected=("$@")
  local i mark pointer
  printf '\033[H\033[J' >&2
  printf 'AI DEV BOOTSTRAP - Select components\n\n' >&2
  printf 'Use arrows or j/k to move, Space to mark [x], Enter to continue, q to quit.\n\n' >&2
  for i in "${!AI_DEV_COMPONENTS[@]}"; do
    mark=" "
    pointer="  "
    [[ "${selected[$i]}" == "1" ]] && mark="x"
    [[ "$i" -eq "$cursor" ]] && pointer="> "
    printf '%s[%s] %-22s %s\n' "$pointer" "$mark" "${AI_DEV_COMPONENTS[$i]}" "${AI_DEV_COMPONENT_CATEGORY[$i]}" >&2
  done
}

prompt_select_components_keyboard() {
  local -a selected=()
  local i key rest cursor selected_count
  cursor=0
  for i in "${!AI_DEV_COMPONENTS[@]}"; do
    selected[$i]=0
  done

  printf '\033[?25l' >&2
  while true; do
    prompt_draw_keyboard_menu "$cursor" "${selected[@]}"
    IFS= read -rsn1 key || {
      printf '\033[?25h\n' >&2
      die "Component selection cancelled"
    }
    case "$key" in
      $'\x1b')
        IFS= read -rsn2 -t 0.1 rest || true
        case "$rest" in
          "[A") cursor=$((cursor > 0 ? cursor - 1 : ${#AI_DEV_COMPONENTS[@]} - 1)) ;;
          "[B") cursor=$((cursor < ${#AI_DEV_COMPONENTS[@]} - 1 ? cursor + 1 : 0)) ;;
        esac
        ;;
      j|J)
        cursor=$((cursor < ${#AI_DEV_COMPONENTS[@]} - 1 ? cursor + 1 : 0))
        ;;
      k|K)
        cursor=$((cursor > 0 ? cursor - 1 : ${#AI_DEV_COMPONENTS[@]} - 1))
        ;;
      " ")
        [[ "${selected[$cursor]}" == "1" ]] && selected[$cursor]=0 || selected[$cursor]=1
        ;;
      q|Q)
        printf '\033[?25h\n' >&2
        die "Component selection cancelled"
        ;;
      "")
        selected_count=0
        for i in "${!selected[@]}"; do
          [[ "${selected[$i]}" == "1" ]] && selected_count=$((selected_count + 1))
        done
        [[ "$selected_count" -gt 0 ]] || continue
        printf '\033[?25h\n' >&2
        for i in "${!selected[@]}"; do
          [[ "${selected[$i]}" == "1" ]] && printf '%s\n' "${AI_DEV_COMPONENTS[$i]}"
        done
        return 0
        ;;
    esac
  done
}

prompt_select_components_numbered() {
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
