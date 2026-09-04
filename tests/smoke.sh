#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/remote-install.sh"

"$ROOT_DIR/bin/ai-dev" list >/tmp/ai-dev-list.out
grep -q "python" /tmp/ai-dev-list.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install python >/tmp/ai-dev-install.out
grep -q "python" /tmp/ai-dev-install.out
grep -q "credentials:" /tmp/ai-dev-install.out

AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install python >/tmp/ai-dev-install-dry-run-no-prompt.out
grep -q "Dry-run complete; no changes made" /tmp/ai-dev-install-dry-run-no-prompt.out
! grep -q "Proceed with install plan" /tmp/ai-dev-install-dry-run-no-prompt.out

printf '10 11\nd\n' | AI_DEV_ALLOW_STDIN_PROMPT=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install >/tmp/ai-dev-install-menu.out
grep -q "node" /tmp/ai-dev-install-menu.out
grep -q "python" /tmp/ai-dev-install-menu.out
grep -q "Dry-run complete; no changes made" /tmp/ai-dev-install-menu.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install --profile ai >/tmp/ai-dev-profile.out
grep -q "opencode" /tmp/ai-dev-profile.out
grep -q "mcp-github" /tmp/ai-dev-profile.out

"$ROOT_DIR/bin/ai-dev" doctor python >/tmp/ai-dev-doctor.out
grep -q "AI DEV BOOTSTRAP - DOCTOR" /tmp/ai-dev-doctor.out

if "$ROOT_DIR/bin/ai-dev" unknown >/tmp/ai-dev-unknown.out 2>&1; then
  echo "unknown command should fail" >&2
  exit 1
fi
grep -q "Unknown command" /tmp/ai-dev-unknown.out

tmpdir="$(mktemp -d)"
(
  cd "$tmpdir"
  "$ROOT_DIR/bin/ai-dev" new sample --stack node --yes >/tmp/ai-dev-new.out
  test -f sample/AGENTS.md
  test -f sample/README.md
  test -f sample/.env.example
  test -f sample/docker-compose.yml
  ! grep -R "{{PROJECT_NAME}}" sample
  "$ROOT_DIR/install.sh" --new custom-name --stack python --yes >/tmp/ai-dev-install-new.out
  test -f custom-name/README.md
  grep -q "custom-name" custom-name/README.md
  mkdir current-project
  cd current-project
  "$ROOT_DIR/bin/ai-dev" new . --stack node --yes >/tmp/ai-dev-new-current.out
  test -f AGENTS.md
  test -f README.md
  test -f openspec/config.yaml
  grep -q "current-project" README.md
)

printf 'smoke tests passed\n'
