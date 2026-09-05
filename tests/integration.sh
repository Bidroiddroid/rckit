#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT
TEST_HOME="$TEST_ROOT/home"
INSTALL_DIR="$TEST_ROOT/install/rckit"
PROJECTS="$TEST_ROOT/projects"
SOURCE_REPO="$TEST_ROOT/source"
mkdir -p "$TEST_HOME" "$PROJECTS" "$SOURCE_REPO"
tar --exclude=.git -C "$ROOT_DIR" -cf - . | tar -C "$SOURCE_REPO" -xf -
git -C "$SOURCE_REPO" init -q
git -C "$SOURCE_REPO" config user.name "rckit tests"
git -C "$SOURCE_REPO" config user.email "tests@localhost"
git -C "$SOURCE_REPO" add .
git -C "$SOURCE_REPO" commit -qm "integration fixture"

HOME="$TEST_HOME" RCKIT_REPO_URL="$SOURCE_REPO" RCKIT_INSTALL_DIR="$INSTALL_DIR" "$ROOT_DIR/remote-install.sh" --profile developer --dry-run >"$TEST_ROOT/remote.out"
rg -q 'Dry-run complete; no changes made' "$TEST_ROOT/remote.out"
test ! -e "$TEST_HOME/.local/bin/ai-dev"

for stack in node python laravel; do
  HOME="$TEST_HOME" RCKIT_REPO_URL="$SOURCE_REPO" RCKIT_INSTALL_DIR="$INSTALL_DIR" "$ROOT_DIR/remote-install.sh" --new "$PROJECTS/$stack-app" --stack "$stack" --yes >/dev/null
  test -f "$PROJECTS/$stack-app/opencode.json"
  test -f "$PROJECTS/$stack-app/openspec/config.yaml"
  test -f "$PROJECTS/$stack-app/.opencode/skills/openspec-apply-change/SKILL.md"
  test -f "$PROJECTS/$stack-app/.opencode/commands/opsx-propose.md"
  test -d "$PROJECTS/$stack-app/openspec/changes/archive"
done
test -L "$TEST_HOME/.local/bin/ai-dev"
HOME="$TEST_HOME" "$TEST_HOME/.local/bin/ai-dev" new "$PROJECTS/idempotent" --stack node --yes >/dev/null
before="$(sha256sum "$PROJECTS/idempotent/README.md")"
HOME="$TEST_HOME" "$TEST_HOME/.local/bin/ai-dev" new "$PROJECTS/idempotent" --stack node --yes >/dev/null
after="$(sha256sum "$PROJECTS/idempotent/README.md")"
[[ "$before" == "$after" ]]
printf 'integration tests passed\n'
