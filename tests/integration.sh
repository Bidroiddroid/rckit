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
grep -q 'Dry-run complete; no changes made' "$TEST_ROOT/remote.out"
test ! -e "$TEST_HOME/.local/bin/ai-dev"

for stack in node python laravel; do
  HOME="$TEST_HOME" RCKIT_REPO_URL="$SOURCE_REPO" RCKIT_INSTALL_DIR="$INSTALL_DIR" "$ROOT_DIR/remote-install.sh" --new "$PROJECTS/$stack-app" --stack "$stack" --yes >/dev/null
  test -f "$PROJECTS/$stack-app/opencode.json"
  test -f "$PROJECTS/$stack-app/openspec/config.yaml"
  test -f "$PROJECTS/$stack-app/.opencode/skills/openspec-apply-change/SKILL.md"
  test -f "$PROJECTS/$stack-app/.opencode/commands/opsx-propose.md"
  test -d "$PROJECTS/$stack-app/openspec/changes/archive"
done

ASTRO_BIN="$TEST_ROOT/astro-bin"
mkdir -p "$ASTRO_BIN"
cat >"$ASTRO_BIN/node" <<'NODE'
#!/usr/bin/env bash
if [[ "${1:-}" == "-p" ]]; then printf '22.12.0\n'; else printf 'v22.12.0\n'; fi
NODE
cat >"$ASTRO_BIN/npm" <<'NPM'
#!/usr/bin/env bash
if [[ "${1:-}" == "--prefix" ]]; then exit 0; fi
target="${4:-}"
mkdir -p "$target/src/pages" "$target/node_modules/.bin"
printf '{"name":"remote-astro","dependencies":{"astro":"latest"}}\n' >"$target/package.json"
printf '<h1>Remote Astro</h1>\n' >"$target/src/pages/index.astro"
printf '# Astro instructions\n' >"$target/AGENTS.md"
printf '#!/usr/bin/env bash\nexit 0\n' >"$target/node_modules/.bin/astro"
chmod +x "$target/node_modules/.bin/astro"
NPM
chmod +x "$ASTRO_BIN/node" "$ASTRO_BIN/npm"
HOME="$TEST_HOME" PATH="$ASTRO_BIN:$PATH" RCKIT_REPO_URL="$SOURCE_REPO" RCKIT_INSTALL_DIR="$INSTALL_DIR" "$ROOT_DIR/remote-install.sh" --new "$PROJECTS/astro-app" --stack astro --yes >/dev/null
test -f "$PROJECTS/astro-app/package.json"
test -f "$PROJECTS/astro-app/src/pages/index.astro"
grep -q 'AI DEV BOOTSTRAP' "$PROJECTS/astro-app/AGENTS.md"
grep -q 'Astro instructions' "$PROJECTS/astro-app/AGENTS.md"
test -f "$PROJECTS/astro-app/opencode.json"
test -f "$PROJECTS/astro-app/openspec/config.yaml"
test -L "$TEST_HOME/.local/bin/ai-dev"
HOME="$TEST_HOME" "$TEST_HOME/.local/bin/ai-dev" new "$PROJECTS/idempotent" --stack node --yes >/dev/null
before="$(sha256sum "$PROJECTS/idempotent/README.md")"
HOME="$TEST_HOME" "$TEST_HOME/.local/bin/ai-dev" new "$PROJECTS/idempotent" --stack node --yes >/dev/null
after="$(sha256sum "$PROJECTS/idempotent/README.md")"
[[ "$before" == "$after" ]]
printf 'integration tests passed\n'
