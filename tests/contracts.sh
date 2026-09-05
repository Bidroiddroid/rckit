#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/install.sh" "$ROOT_DIR/bin/ai-dev" "$ROOT_DIR"/lib/*.sh "$ROOT_DIR"/modules/*/module.sh "$ROOT_DIR"/modules/security/*/module.sh "$ROOT_DIR"/modules/mcp/*/module.sh

"$ROOT_DIR/bin/ai-dev" list >/tmp/ai-dev-contract-list.out
grep -q "mcp-github" /tmp/ai-dev-contract-list.out
grep -q "semgrep" /tmp/ai-dev-contract-list.out
grep -q "astro" /tmp/ai-dev-contract-list.out
grep -q "agent-skills" /tmp/ai-dev-contract-list.out
grep -q 'dependencies: \[node\]' "$ROOT_DIR/config/manifest.yaml"
grep -A6 '^  agent-skills:' "$ROOT_DIR/config/manifest.yaml" | grep -q 'dependencies: \[git, node\]'
grep -A6 '^  agent-skills:' "$ROOT_DIR/config/manifest.yaml" | grep -q 'credentials: false'
grep -A6 '^  agent-skills:' "$ROOT_DIR/config/manifest.yaml" | grep -q 'context_cost: high'
! grep -A40 '^  ai:' "$ROOT_DIR/config/profiles.yaml" | grep -q -- '- agent-skills'
grep -q '22.12.0' "$ROOT_DIR/modules/node/module.sh"
grep -q 'npm create astro@latest' "$ROOT_DIR/lib/scaffold.sh"
grep -q 'vercel-labs/agent-skills' "$ROOT_DIR/modules/agent-skills/module.sh"

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
grep -q '"agent"' /tmp/ai-dev-opencode-json.out
grep -q '"bash": "ask"' /tmp/ai-dev-opencode-json.out
grep -q '"enabled": true' "$ROOT_DIR/templates/opencode/mcp/context7.json"
grep -q "schema: spec-driven" "$ROOT_DIR/templates/openspec/config.yaml"
grep -q "{{PROJECT_NAME}}" "$ROOT_DIR/templates/openspec/config.yaml"
grep -q "Conhecimento caro" "$ROOT_DIR/templates/openspec/config.yaml"
grep -q "proposal:" "$ROOT_DIR/templates/openspec/config.yaml"
grep -q "design:" "$ROOT_DIR/templates/openspec/config.yaml"
grep -q "specs:" "$ROOT_DIR/templates/openspec/config.yaml"
grep -q "tasks:" "$ROOT_DIR/templates/openspec/config.yaml"
test -f "$ROOT_DIR/templates/openspec/README.md"
test -f "$ROOT_DIR/templates/openspec/changes/.gitkeep"
test -f "$ROOT_DIR/templates/openspec/changes/archive/.gitkeep"
test -f "$ROOT_DIR/templates/openspec/specs/.gitkeep"
test -f "$ROOT_DIR/skills/code-review/SKILL.md"
  test -f "$ROOT_DIR/skills/mcp-setup/SKILL.md"
test -f "$ROOT_DIR/.codex/skills/openspec-propose/SKILL.md"
test -f "$ROOT_DIR/templates/opencode/openspec-core/commands/opsx-apply.md"
test "$(wc -l <"$ROOT_DIR/templates/openspec/config.yaml")" -gt 200
if grep -R -n -E "ghp_|github_pat_|sk-[A-Za-z0-9]{16}|xox[baprs]-|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|postgres://[^{}[:space:]]+:[^{}[:space:]]+@" "$ROOT_DIR/templates/opencode" "$ROOT_DIR/templates/openspec"; then
  echo "real-looking secret found in templates" >&2
  exit 1
fi

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install laravel >/tmp/ai-dev-contract-laravel.out
grep -q "php" /tmp/ai-dev-contract-laravel.out
grep -q "laravel" /tmp/ai-dev-contract-laravel.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install agent-skills >/tmp/ai-dev-contract-skills.out
grep -q 'source: https://github.com/vercel-labs/agent-skills' /tmp/ai-dev-contract-skills.out
grep -q 'context: high' /tmp/ai-dev-contract-skills.out
grep -q 'credentials: false' /tmp/ai-dev-contract-skills.out
grep -q 'node' /tmp/ai-dev-contract-skills.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" install mcp-github >/tmp/ai-dev-contract-mcp.out
grep -q "opencode" /tmp/ai-dev-contract-mcp.out
! grep -q "github-cli" /tmp/ai-dev-contract-mcp.out
grep -q "credentials: true" /tmp/ai-dev-contract-mcp.out

AI_DEV_YES=1 AI_DEV_DRY_RUN=1 "$ROOT_DIR/bin/ai-dev" remove postgresql >/tmp/ai-dev-contract-remove.out
grep -q "Destructive guard" /tmp/ai-dev-contract-remove.out
! grep -q ' - system ' /tmp/ai-dev-contract-remove.out
! grep -q ' - docker ' /tmp/ai-dev-contract-remove.out

if "$ROOT_DIR/bin/ai-dev" verify python >/tmp/ai-dev-contract-verify.out; then
  grep -q "Environment: READY" /tmp/ai-dev-contract-verify.out
else
  grep -q "Environment: UNHEALTHY" /tmp/ai-dev-contract-verify.out
fi

"$ROOT_DIR/bin/ai-dev" doctor docker >/tmp/ai-dev-contract-doctor.out
grep -q "Docker" /tmp/ai-dev-contract-doctor.out

"$ROOT_DIR/bin/ai-dev" doctor mcp-github >/tmp/ai-dev-contract-mcp-doctor.out
grep -q "mcp-github" /tmp/ai-dev-contract-mcp-doctor.out
grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" /tmp/ai-dev-contract-mcp-doctor.out
grep -q "MCP server" /tmp/ai-dev-contract-mcp-doctor.out

state_root="$(mktemp -d)"
(
  AI_DEV_ROOT="$state_root"
  source "$ROOT_DIR/lib/logging.sh"
  source "$ROOT_DIR/lib/state.sh"
  state_mark git installed 1
  state_mark git updated 2
  test "$(grep -c '^  git:$' "$state_root/state/installed.yaml")" -eq 1
  grep -q 'version: "2"' "$state_root/state/installed.yaml"
)

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
cat >"$tmpbin/node" <<'NODE'
#!/usr/bin/env bash
if [[ "${2:-}" == *'% 2'* ]]; then
  printf '0\n'
elif [[ "${1:-}" == "-p" ]]; then
  printf '22.12.0\n'
else
  printf 'v22.12.0\n'
fi
NODE
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/npm"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/npx"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/pnpm"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/tsc"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/corepack"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/opencode"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/mise"
printf '#!/usr/bin/env bash\nexit 0\n' >"$tmpbin/google-chrome"
chmod +x "$tmpbin/node" "$tmpbin/npm" "$tmpbin/npx" "$tmpbin/pnpm" "$tmpbin/tsc" "$tmpbin/corepack" "$tmpbin/opencode" "$tmpbin/mise" "$tmpbin/google-chrome"
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

for service in postgresql redis mysql traefik portainer; do
  test -f "$ROOT_DIR/templates/services/$service.compose.yml"
  grep -q '^services:' "$ROOT_DIR/templates/services/$service.compose.yml"
done
(
  cd "$tmpdir"
  "$ROOT_DIR/bin/ai-dev" new agent-check --stack node --yes >/tmp/ai-dev-contract-agent-new.out
  grep -q "OpenSpec" agent-check/AGENTS.md
  grep -q "MCP Usage" agent-check/AGENTS.md
  grep -q "Never commit" agent-check/AGENTS.md
  test -f agent-check/opencode.json
  test -f agent-check/.opencode/skills/openspec-apply-change/SKILL.md
  ! grep -R "{{PROJECT_NAME}}" agent-check
)

printf 'contract tests passed\n'
