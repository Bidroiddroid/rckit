#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${BASH_VERSION:-}" ]]; then
  echo "AI DEV BOOTSTRAP requires Bash." >&2
  exit 2
fi

if [[ ! -x "$ROOT_DIR/bin/ai-dev" ]]; then
  echo "Missing executable: $ROOT_DIR/bin/ai-dev" >&2
  echo "Run: chmod +x bin/ai-dev install.sh" >&2
  exit 2
fi

exec "$ROOT_DIR/bin/ai-dev" install "$@"
