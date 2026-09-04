## Why

Developers need a repeatable way to turn a clean Ubuntu, Debian, or WSL2 machine into a professional AI-assisted development environment from a GitHub-hosted bootstrap repository. This change introduces AI DEV BOOTSTRAP as a modular environment manager that can be cloned or downloaded when starting a new machine or system, then install only the components selected by the user while preserving existing state and security boundaries.

## What Changes

- Add a production-oriented `ai-dev` CLI distributed from the repository for installing, updating, verifying, diagnosing, enabling, disabling, removing, listing, and scaffolding development environment components.
- Add a repository bootstrap entrypoint so a user can clone the GitHub repository and start setup without manually wiring internal scripts.
- Add a declarative component manifest and profile system so users can select languages, frameworks, infrastructure, AI tools, MCPs, and security tooling while dependencies are resolved automatically.
- Add a module contract for component lifecycle operations: detect, install, configure, verify, update, remove, and doctor.
- Add persistent installation state and logs while always validating the real system instead of trusting state files alone.
- Add first-version support for Ubuntu, Debian, and WSL2 Ubuntu, with architecture prepared for Fedora, Arch, macOS, and Windows support later.
- Add initial modules for Node.js/TypeScript, Python, PHP/Laravel, Git, GitHub CLI, Make, jq, yq, ripgrep, fd, mise, Docker, Docker Compose, Portainer, Traefik, PostgreSQL, Redis, OpenCode, OpenSpec, selected MCP integrations, Gitleaks, Trivy, and Semgrep.
- Add secure OpenCode + OpenSpec integration including templates for `opencode.json`, AGENTS.md, skills, commands, MCP configuration, and permission defaults.
- Add `ai-dev new` project scaffolding with stack-aware templates for AGENTS.md, README, environment examples, OpenSpec, OpenCode, docs, tests, and Docker Compose.
- Add automated tests for platform detection, dependency resolution, component selection, lifecycle idempotency, state handling, verification, diagnostics, and error paths.

No breaking changes are expected because this repository currently has no implemented application code.

## Capabilities

### New Capabilities

- `ai-dev-cli`: Command-line interface, interactive install flow, command routing, profiles, selections, summaries, confirmations, and cancellation.
- `component-catalog`: Declarative manifest, dependency resolution, profiles, categories, component metadata, and module discovery.
- `component-lifecycle`: Idempotent component detection, installation, configuration, verification, update, removal, diagnostics, state reconciliation, and logging.
- `platform-support`: Operating system, distribution, shell, architecture, user, privilege, and package manager detection for supported environments.
- `ai-tooling-integration`: OpenCode, OpenSpec, MCP, agents, skills, permissions, and secure credential configuration.
- `development-stack-modules`: Language, framework, development tool, infrastructure, database, and security modules included in the first release.
- `project-scaffolding`: `ai-dev new` stack-aware project template generation.
- `security-observability`: Secret handling, destructive-action safeguards, audit-friendly logs, verification reports, and security scanner integration.

### Modified Capabilities

- None.

## Impact

- Adds a new CLI application, module runtime, configuration files, templates, tests, and documentation under the repository.
- Introduces runtime dependencies for a modern cross-platform CLI, YAML parsing, interactive prompts, logging, command execution, and test tooling.
- Affects host machines by installing and configuring selected tools only after explicit user choice and confirmation.
- The repository itself becomes the reusable distribution artifact the user keeps in GitHub and reuses on new systems.
- Requires documentation-source tracking for integration-specific installation and configuration decisions.
