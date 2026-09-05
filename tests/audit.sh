#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash -n "$ROOT_DIR/install.sh" "$ROOT_DIR/remote-install.sh" "$ROOT_DIR/bin/ai-dev" "$ROOT_DIR"/lib/*.sh "$ROOT_DIR"/modules/*/module.sh "$ROOT_DIR"/modules/mcp/*/module.sh "$ROOT_DIR"/modules/security/*/module.sh

if rg -n 'Install placeholder|Configure placeholder|Update placeholder|installer is not implemented' "$ROOT_DIR/lib" "$ROOT_DIR/modules"; then
  echo "functional placeholder found" >&2
  exit 1
fi

for name in postgresql redis mysql traefik portainer; do
  rg -q "service_verify $name" "$ROOT_DIR/modules/$name/module.sh"
  test -f "$ROOT_DIR/templates/services/$name.compose.yml"
done
for name in context7 github playwright postgresql sentry chrome-devtools firecrawl; do
  python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/$name.json" >/dev/null
done
python3 -m json.tool "$ROOT_DIR/templates/opencode/opencode.json" >/dev/null
"$ROOT_DIR/tests/openspec-parity.sh"
rg -q 'opencode.json.*raiz' "$ROOT_DIR/README.md"
rg -q '@fission-ai/openspec@latest' "$ROOT_DIR/modules/openspec/module.sh"
rg -q 'npm install -g opencode-ai' "$ROOT_DIR/modules/opencode/module.sh"
for command in '--profile developer --dry-run' '--new meu-projeto --stack node' '--new . --stack node' 'ai-dev install python --dry-run'; do
  rg -q -- "$command" "$ROOT_DIR/README.md"
done

if rg -n 'ghp_|github_pat_|sk-[A-Za-z0-9]{16}|xox[baprs]-|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}' "$ROOT_DIR" -g '!projeto/**' -g '!tests/audit.sh' -g '!tests/contracts.sh'; then
  echo "real-looking secret found" >&2
  exit 1
fi
printf 'audit tests passed\n'
