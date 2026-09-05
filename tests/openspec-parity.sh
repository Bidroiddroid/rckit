#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED="$ROOT_DIR/templates/opencode/openspec-core"
CORE=(openspec-propose openspec-explore openspec-apply-change openspec-archive-change)
COMMANDS=(opsx-propose opsx-explore opsx-apply opsx-archive)

for name in "${CORE[@]}"; do
  test -s "$EXPECTED/skills/$name/SKILL.md"
done
for name in "${COMMANDS[@]}"; do
  test -s "$EXPECTED/commands/$name.md"
done
test -f "$ROOT_DIR/templates/openspec/changes/archive/.gitkeep"

if command -v openspec >/dev/null 2>&1; then
  probe="$(mktemp -d)"
  trap 'rm -rf "$probe"' EXIT
  mkdir -p "$probe/home" "$probe/project"
  HOME="$probe/home" OPENSPEC_TELEMETRY=0 openspec config set delivery both >/dev/null
  HOME="$probe/home" OPENSPEC_TELEMETRY=0 openspec init "$probe/project" --tools opencode --profile core --force >/dev/null
  for name in "${CORE[@]}"; do
    cmp "$probe/project/.opencode/skills/$name/SKILL.md" "$EXPECTED/skills/$name/SKILL.md"
  done
  for name in "${COMMANDS[@]}"; do
    cmp "$probe/project/.opencode/commands/$name.md" "$EXPECTED/commands/$name.md"
  done
fi

printf 'OpenSpec parity tests passed\n'
