#!/usr/bin/env bash

platform_detect() {
  AI_DEV_OS="$(uname -s 2>/dev/null || printf unknown)"
  AI_DEV_ARCH="$(uname -m 2>/dev/null || printf unknown)"
  AI_DEV_DIST_ID="unknown"
  AI_DEV_DIST_VERSION="unknown"
  AI_DEV_WSL="false"
  AI_DEV_SHELL_NAME="$(basename "${SHELL:-unknown}")"
  AI_DEV_USER_NAME="$(id -un 2>/dev/null || printf unknown)"
  AI_DEV_IS_ROOT="false"
  [[ "$(id -u 2>/dev/null || printf 1)" == "0" ]] && AI_DEV_IS_ROOT="true"
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    AI_DEV_DIST_ID="${ID:-unknown}"
    AI_DEV_DIST_VERSION="${VERSION_ID:-unknown}"
  fi
  if grep -qi microsoft /proc/version 2>/dev/null; then
    AI_DEV_WSL="true"
  fi
  AI_DEV_PACKAGE_MANAGER="unknown"
  if command -v apt-get >/dev/null 2>&1; then
    AI_DEV_PACKAGE_MANAGER="apt"
  elif command -v dnf >/dev/null 2>&1; then
    AI_DEV_PACKAGE_MANAGER="dnf"
  elif command -v pacman >/dev/null 2>&1; then
    AI_DEV_PACKAGE_MANAGER="pacman"
  elif command -v brew >/dev/null 2>&1; then
    AI_DEV_PACKAGE_MANAGER="brew"
  fi
}

platform_print() {
  platform_detect
  cat <<EOF
os: $AI_DEV_OS
distribution: $AI_DEV_DIST_ID
version: $AI_DEV_DIST_VERSION
wsl2: $AI_DEV_WSL
architecture: $AI_DEV_ARCH
shell: $AI_DEV_SHELL_NAME
user: $AI_DEV_USER_NAME
root: $AI_DEV_IS_ROOT
package_manager: $AI_DEV_PACKAGE_MANAGER
EOF
}

platform_is_supported() {
  platform_detect
  [[ "$AI_DEV_OS" == "Linux" ]] || return 1
  [[ "$AI_DEV_DIST_ID" == "ubuntu" || "$AI_DEV_DIST_ID" == "debian" ]] || return 1
}

platform_require_supported() {
  local action="${1:-operation}"
  if ! platform_is_supported; then
    die "$action is supported first on Ubuntu, Debian, and WSL2 Ubuntu. Detected: $AI_DEV_OS/$AI_DEV_DIST_ID."
  fi
}
