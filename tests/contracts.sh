#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/install.sh" "$ROOT_DIR/bin/ai-dev" "$ROOT_DIR"/lib/*.sh "$ROOT_DIR"/modules/*/module.sh "$ROOT_DIR"/modules/security/*/module.sh "$ROOT_DIR"/modules/mcp/*/module.sh

"$ROOT_DIR/bin/ai-dev" list >/tmp/ai-dev-contract-list.out
grep -q "mcp-github" /tmp/ai-dev-contract-list.out
grep -q "semgrep" /tmp/ai-dev-contract-list.out

tmpbin_fd="$(mktemp -d)"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin_fd/fdfind"
chmod +x "$tmpbin_fd/fdfind"
PATH="$tmpbin_fd:$PATH" "$ROOT_DIR/bin/ai-dev" verify fd >/tmp/ai-dev-contract-fd.out
grep -q "Environment: READY" /tmp/ai-dev-contract-fd.out

python3 -m json.tool "$ROOT_DIR/templates/opencode/opencode.json" >/tmp/ai-dev-opencode-json.out
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/context7.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/github.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/playwright.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/postgresql.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/sentry.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/chrome-devtools.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/opencode/mcp/firecrawl.json" >/dev/null
grep -q '"mcp"' /tmp/ai-dev-opencode-json.out
grep -q '"enabled": true' "$ROOT_DIR/templates/opencode/mcp/context7.json"

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install laravel >/tmp/ai-dev-contract-laravel.out
grep -q "php" /tmp/ai-dev-contract-laravel.out
grep -q "laravel" /tmp/ai-dev-contract-laravel.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install mcp-github >/tmp/ai-dev-contract-mcp.out
grep -q "opencode" /tmp/ai-dev-contract-mcp.out
! grep -q "github-cli" /tmp/ai-dev-contract-mcp.out
grep -q "credentials: true" /tmp/ai-dev-contract-mcp.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" remove postgresql >/tmp/ai-dev-contract-remove.out
grep -q "Destructive guard" /tmp/ai-dev-contract-remove.out

"$ROOT_DIR/bin/ai-dev" verify python >/tmp/ai-dev-contract-verify.out
grep -q "Environment:" /tmp/ai-dev-contract-verify.out

"$ROOT_DIR/bin/ai-dev" doctor docker >/tmp/ai-dev-contract-doctor.out
grep -q "Docker" /tmp/ai-dev-contract-doctor.out

"$ROOT_DIR/bin/ai-dev" doctor mcp-github >/tmp/ai-dev-contract-mcp-doctor.out
grep -q "mcp-github" /tmp/ai-dev-contract-mcp-doctor.out
grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" /tmp/ai-dev-contract-mcp-doctor.out
grep -q "MCP server" /tmp/ai-dev-contract-mcp-doctor.out

if "$ROOT_DIR/bin/ai-dev" verify mcp-github >/tmp/ai-dev-contract-mcp-verify.out 2>&1; then
  if ! grep -q "Environment: READY" /tmp/ai-dev-contract-mcp-verify.out; then
    echo "MCP verify returned success without READY status" >&2
    exit 1
  fi
else
  grep -q "Environment: UNHEALTHY" /tmp/ai-dev-contract-mcp-verify.out
fi

tmpdir="$(mktemp -d)"
tmpbin="$tmpdir/bin"
tmphome="$tmpdir/home"
mkdir -p "$tmpbin" "$tmphome"
printf '#!/usr/bin/env bash\nprintf "v20.0.0\\n"\n' >"$tmpbin/node"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/npm"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/npx"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/opencode"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/mise"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/google-chrome"
chmod +x "$tmpbin/node" "$tmpbin/npm" "$tmpbin/npx" "$tmpbin/opencode" "$tmpbin/mise" "$tmpbin/google-chrome"
(
  PATH="$tmpbin:$PATH"
  HOME="$tmphome"
  AI_DEV_YES=1
  GITHUB_PERSONAL_ACCESS_TOKEN=test-token
  DATABASE_URL=postgresql://user:pass@localhost:5432/app
  FIRECRAWL_API_KEY=test-key
  export PATH HOME AI_DEV_YES GITHUB_PERSONAL_ACCESS_TOKEN DATABASE_URL FIRECRAWL_API_KEY
  "$ROOT_DIR/bin/ai-dev" install mcp-context7 mcp-github mcp-playwright mcp-postgresql mcp-sentry mcp-chrome-devtools mcp-firecrawl >/tmp/ai-dev-contract-mcp-install.out
)
test -f "$tmphome/.config/opencode/opencode.json"
python3 - "$tmphome/.config/opencode/opencode.json" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as fh:
    data = json.load(fh)
expected = {
    "context7",
    "github",
    "playwright",
    "postgresql",
    "sentry",
    "chrome-devtools",
    "firecrawl",
}
servers = data.get("mcp", {})
missing = sorted(expected - set(servers))
if missing:
    raise SystemExit(f"missing MCP config entries: {missing}")
for name in expected:
    if servers[name].get("disabled") is True:
        raise SystemExit(f"MCP config is disabled: {name}")
    if servers[name].get("enabled") is not True:
        raise SystemExit(f"MCP config is not explicitly enabled: {name}")
PY
(
  cd "$tmpdir"
  "$ROOT_DIR/bin/ai-dev" new agent-check --stack node --yes >/tmp/ai-dev-contract-agent-new.out
  grep -q "OpenSpec" agent-check/AGENTS.md
  grep -q "MCP Usage" agent-check/AGENTS.md
  grep -q "Never commit" agent-check/AGENTS.md
  ! grep -R "{{PROJECT_NAME}}" agent-check
)

printf 'contract tests passed\n'
