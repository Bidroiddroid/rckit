#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="${RCKIT_REPO_URL:-https://github.com/Bidroiddroid/rckit.git}"
INSTALL_DIR="${RCKIT_INSTALL_DIR:-$HOME/.local/share/rckit}"

need_command() {
  command -v "$1" >/dev/null 2>&1
}

install_git_if_missing() {
  if need_command git; then
    return 0
  fi
  if ! need_command sudo; then
    echo "git is missing and sudo is unavailable. Install git first." >&2
    exit 2
  fi
  if need_command apt-get; then
    sudo apt-get update
    sudo apt-get install -y git
    return 0
  fi
  echo "git is missing and this bootstrap currently auto-installs it only with apt-get." >&2
  exit 2
}

sync_repository() {
  mkdir -p "$(dirname "$INSTALL_DIR")"
  if [[ -d "$INSTALL_DIR/.git" ]]; then
    git -C "$INSTALL_DIR" pull --ff-only
  elif [[ -e "$INSTALL_DIR" ]]; then
    echo "Install directory exists but is not a Git repository: $INSTALL_DIR" >&2
    echo "Set RCKIT_INSTALL_DIR to another path or move the existing directory." >&2
    exit 2
  else
    git clone "$REPO_URL" "$INSTALL_DIR"
  fi
}

main() {
  install_git_if_missing
  sync_repository
  chmod +x "$INSTALL_DIR/install.sh" "$INSTALL_DIR/bin/ai-dev"
  exec "$INSTALL_DIR/install.sh" "$@"
}

main "$@"
