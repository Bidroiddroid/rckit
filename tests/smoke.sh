#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT_DIR/remote-install.sh"

"$ROOT_DIR/bin/ai-dev" list >/tmp/ai-dev-list.out
grep -q "python" /tmp/ai-dev-list.out
grep -q "astro" /tmp/ai-dev-list.out
grep -q "agent-skills" /tmp/ai-dev-list.out

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

dry_astro="$(mktemp -u)/astro-dry-run"
"$ROOT_DIR/bin/ai-dev" new "$dry_astro" --stack astro --dry-run >/tmp/ai-dev-astro-dry.out
grep -q 'npm create astro@latest' /tmp/ai-dev-astro-dry.out
test ! -e "$dry_astro"

tmpdir="$(mktemp -d)"
(
  cd "$tmpdir"
  "$ROOT_DIR/bin/ai-dev" new sample --stack node --yes >/tmp/ai-dev-new.out
  test -f sample/AGENTS.md
  test -f sample/README.md
  test -f sample/.env.example
  test -f sample/docker-compose.yml
  test -d sample/openspec/changes
  test -d sample/openspec/changes/archive
  test -d sample/openspec/specs
  test -f sample/openspec/README.md
  test -f sample/.opencode/skills/code-review/SKILL.md
  test -f sample/.opencode/skills/mcp-setup/SKILL.md
  test -f sample/.opencode/skills/openspec-apply-change/SKILL.md
  test -f sample/.opencode/commands/opsx-propose.md
  test -f sample/.opencode/commands/opsx-explore.md
  test -f sample/.opencode/commands/opsx-apply.md
  test -f sample/.opencode/commands/opsx-archive.md
  cmp "$ROOT_DIR/templates/opencode/openspec-core/skills/openspec-propose/SKILL.md" sample/.opencode/skills/openspec-propose/SKILL.md
  python3 -m json.tool sample/opencode.json >/tmp/ai-dev-sample-opencode-json.out
  grep -q '"agent"' /tmp/ai-dev-sample-opencode-json.out
  grep -q '"mcp"' /tmp/ai-dev-sample-opencode-json.out
  grep -q '"bash": "ask"' /tmp/ai-dev-sample-opencode-json.out
  grep -q "schema: spec-driven" sample/openspec/config.yaml
  grep -q "Conhecimento caro" sample/openspec/config.yaml
  grep -q "proposal:" sample/openspec/config.yaml
  grep -q "design:" sample/openspec/config.yaml
  grep -q "specs:" sample/openspec/config.yaml
  grep -q "tasks:" sample/openspec/config.yaml
  ! grep -R "{{PROJECT_NAME}}" sample
  "$ROOT_DIR/install.sh" --new custom-name --stack python --yes >/tmp/ai-dev-install-new.out
  test -f custom-name/README.md
  grep -q "custom-name" custom-name/README.md
  grep -q "custom-name" custom-name/openspec/config.yaml
  "$ROOT_DIR/bin/ai-dev" new "$tmpdir/nested/absolute-name" --stack node --yes >/tmp/ai-dev-new-absolute.out
  grep -q "absolute-name" "$tmpdir/nested/absolute-name/README.md"
  grep -q "Conhecimento caro" custom-name/openspec/config.yaml
  mkdir current-project
  cd current-project
  "$ROOT_DIR/bin/ai-dev" new . --stack node --yes >/tmp/ai-dev-new-current.out
  test -f AGENTS.md
  test -f README.md
  test -f openspec/config.yaml
  test -d openspec/changes
  test -d openspec/changes/archive
  test -d openspec/specs
  test -f openspec/README.md
  test -f .opencode/skills/code-review/SKILL.md
  test -f .opencode/skills/openspec-propose/SKILL.md
  test -f .opencode/commands/opsx-apply.md
  test -f opencode.json
  grep -q "current-project" README.md
  grep -q "current-project" openspec/config.yaml
  grep -q "schema: spec-driven" openspec/config.yaml
  grep -q "Conhecimento caro" openspec/config.yaml
  cd "$tmpdir"
  mkdir legacy-project
  cd legacy-project
  mkdir -p openspec .opencode/commands .opencode/skills/openspec-propose
  printf 'version: 1\nproject: legacy-project\n' >openspec/config.yaml
  printf '{"mcp":{}}\n' >.opencode/opencode.json
  printf 'custom command\n' >.opencode/commands/custom.md
  printf 'legacy skill\n' >.opencode/skills/openspec-propose/SKILL.md
  "$ROOT_DIR/bin/ai-dev" new . --stack node --yes >/tmp/ai-dev-new-legacy.out
  test -f openspec/config.yaml.old.*
  test -f opencode.json
  test -f .opencode/opencode.json
  test -f .opencode/commands/custom.md
  test -f .opencode/commands/opsx-propose.md
  test -f .opencode/skills/openspec-propose/SKILL.md.old.*
  cmp "$ROOT_DIR/templates/opencode/openspec-core/skills/openspec-propose/SKILL.md" .opencode/skills/openspec-propose/SKILL.md
  grep -q "Conhecimento caro" openspec/config.yaml
  grep -q '"mcp"' opencode.json
)

astro_test="$(mktemp -d)"
astro_bin="$astro_test/bin"
mkdir -p "$astro_bin"
cat >"$astro_bin/node" <<'NODE'
#!/usr/bin/env bash
if [[ "${2:-}" == *'% 2'* ]]; then printf '0\n'; elif [[ "${1:-}" == "-p" ]]; then printf '22.12.0\n'; else printf 'v22.12.0\n'; fi
NODE
cat >"$astro_bin/npm" <<'NPM'
#!/usr/bin/env bash
target="${4:-}"
mkdir -p "$target/src/pages"
printf '{"name":"mock-astro","dependencies":{"astro":"latest"}}\n' >"$target/package.json"
printf '<h1>Astro</h1>\n' >"$target/src/pages/index.astro"
printf '# Astro instructions\n' >"$target/AGENTS.md"
NPM
chmod +x "$astro_bin/node" "$astro_bin/npm"
(
  cd "$astro_test"
  HOME="$astro_test/home" PATH="$astro_bin:$PATH" "$ROOT_DIR/bin/ai-dev" new astro-app --stack astro --yes >/tmp/ai-dev-astro-new.out
  test -f astro-app/package.json
  test -f astro-app/src/pages/index.astro
  test -f astro-app/AGENTS.md
  grep -q 'AI DEV BOOTSTRAP' astro-app/AGENTS.md
  grep -q 'Astro instructions' astro-app/AGENTS.md
  test -f astro-app/opencode.json
  test -f astro-app/openspec/config.yaml
  original="$(sha256sum astro-app/package.json)"
  HOME="$astro_test/home" PATH="$astro_bin:$PATH" "$ROOT_DIR/bin/ai-dev" new astro-app --stack astro --yes >/tmp/ai-dev-astro-existing.out
  [[ "$original" == "$(sha256sum astro-app/package.json)" ]]
)

skills_test="$(mktemp -d)"
skills_bin="$skills_test/bin"
skills_project="$skills_test/project"
mkdir -p "$skills_bin" "$skills_project/.agents/skills/custom"
printf '# Agent\n' >"$skills_project/AGENTS.md"
printf '%s\n' '---' 'name: custom' 'description: custom' '---' >"$skills_project/.agents/skills/custom/SKILL.md"
cat >"$skills_bin/node" <<'NODE'
#!/usr/bin/env bash
if [[ "${2:-}" == *'% 2'* ]]; then printf '0\n'; elif [[ "${1:-}" == "-p" ]]; then printf '22.12.0\n'; else printf 'v22.12.0\n'; fi
NODE
for cmd in npm git pnpm tsc corepack mise; do printf '#!/usr/bin/env bash\nexit 0\n' >"$skills_bin/$cmd"; done
cat >"$skills_bin/npx" <<'NPX'
#!/usr/bin/env bash
mkdir -p .agents/skills/web-design-guidelines
printf '%s\n' '---' 'name: web-design-guidelines' 'description: Vercel guidelines' '---' >.agents/skills/web-design-guidelines/SKILL.md
printf '{"sources":[{"source":"vercel-labs/agent-skills"}]}\n' >skills-lock.json
NPX
chmod +x "$skills_bin"/*
(
  cd "$skills_project"
  HOME="$skills_test/home" PATH="$skills_bin:$PATH" AI_DEV_YES=1 "$ROOT_DIR/bin/ai-dev" install agent-skills >/tmp/ai-dev-skills-install.out
  test -f .agents/skills/custom/SKILL.md
  test -f .agents/skills/web-design-guidelines/SKILL.md
  "$ROOT_DIR/bin/ai-dev" verify agent-skills >/tmp/ai-dev-skills-verify.out
  grep -q 'Environment: READY' /tmp/ai-dev-skills-verify.out
  if HOME="$skills_test/home" PATH="$skills_bin:$PATH" AI_DEV_YES=1 "$ROOT_DIR/bin/ai-dev" remove agent-skills >/tmp/ai-dev-skills-remove.out 2>&1; then
    echo 'agent-skills automatic removal should be refused' >&2
    exit 1
  fi
  test -f .agents/skills/custom/SKILL.md
)

printf 'smoke tests passed\n'
