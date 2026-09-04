#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/install.sh" "$ROOT_DIR/bin/ai-dev" "$ROOT_DIR"/lib/*.sh "$ROOT_DIR"/modules/*/module.sh "$ROOT_DIR"/modules/security/*/module.sh "$ROOT_DIR"/modules/mcp/*/module.sh

"$ROOT_DIR/bin/ai-dev" list >/tmp/ai-dev-contract-list.out
grep -q "mcp-github" /tmp/ai-dev-contract-list.out
grep -q "semgrep" /tmp/ai-dev-contract-list.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install laravel >/tmp/ai-dev-contract-laravel.out
grep -q "php" /tmp/ai-dev-contract-laravel.out
grep -q "laravel" /tmp/ai-dev-contract-laravel.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install mcp-github >/tmp/ai-dev-contract-mcp.out
grep -q "opencode" /tmp/ai-dev-contract-mcp.out
grep -q "github-cli" /tmp/ai-dev-contract-mcp.out
grep -q "credentials: true" /tmp/ai-dev-contract-mcp.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" remove postgresql >/tmp/ai-dev-contract-remove.out
grep -q "Destructive guard" /tmp/ai-dev-contract-remove.out

"$ROOT_DIR/bin/ai-dev" verify python >/tmp/ai-dev-contract-verify.out
grep -q "Environment:" /tmp/ai-dev-contract-verify.out

"$ROOT_DIR/bin/ai-dev" doctor docker >/tmp/ai-dev-contract-doctor.out
grep -q "Docker" /tmp/ai-dev-contract-doctor.out

printf 'contract tests passed\n'
