#!/usr/bin/env bash
AI_DEV_MODULE_NAME="Vercel Agent Skills"
AI_DEV_MODULE_BINARY="npx"
source "$AI_DEV_ROOT/lib/module-default.sh"

agent_skills_root() { printf '%s/.agents/skills\n' "$PWD"; }
agent_skills_lock() { printf '%s/skills-lock.json\n' "$PWD"; }
agent_skills_project_valid() { [[ -f "$PWD/AGENTS.md" || -f "$PWD/package.json" || -d "$PWD/.git" || -d "$PWD/openspec" ]]; }
agent_skills_files_exist() { find "$(agent_skills_root)" -mindepth 2 -maxdepth 2 -name SKILL.md -type f -print -quit 2>/dev/null | grep -q .; }

module_verify() {
  agent_skills_project_valid && [[ -f "$(agent_skills_lock)" ]] && grep -q 'vercel-labs/agent-skills' "$(agent_skills_lock)" && agent_skills_files_exist
}

module_install() {
  require_command node
  require_command npm
  require_command npx
  require_command git
  agent_skills_project_valid || die "agent-skills must run from a project root (AGENTS.md, package.json, .git, or openspec required)"
  run_cmd env DISABLE_TELEMETRY=1 npx --yes skills add vercel-labs/agent-skills --skill '*' --agent opencode --agent codex --copy --yes
}

module_configure() { module_verify "$1" || [[ "${AI_DEV_DRY_RUN:-0}" == "1" ]] || die "Vercel agent skills installation is incomplete; inspect skills-lock.json and .agents/skills"; }
module_update() { require_command npx; agent_skills_project_valid || die "agent-skills must run from a project root"; run_cmd env DISABLE_TELEMETRY=1 npx --yes skills update --project --yes; }

module_remove() {
  agent_skills_project_valid || die "agent-skills must run from a project root"
  [[ -f "$(agent_skills_lock)" ]] || die "Cannot prove agent skill ownership without skills-lock.json; preserving project files"
  die "Automatic removal is refused because the shared skills lock can include user collections; use 'npx skills remove <skill>' for reviewed skill names"
}

module_doctor() {
  command_exists node || printf '[WARN] agent-skills requires Node.js.\n'
  command_exists npx || printf '[WARN] agent-skills requires npx.\n'
  command_exists git || printf '[WARN] agent-skills requires Git.\n'
  agent_skills_project_valid || { printf '[WARN] Run agent-skills from a project root.\n'; return 0; }
  module_verify "$1" && printf '[OK] vercel-labs/agent-skills is installed and tracked for this project.\n' || printf '[WARN] Collection is absent or incomplete; run ai-dev install agent-skills from the project root.\n'
}
