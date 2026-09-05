## 1. Repository Bootstrap

- [x] 1.1 Create the repository structure for `bin/`, `lib/`, `config/`, `modules/`, `templates/`, `skills/`, `state/`, `logs/`, `tests/`, and `docs/`.
- [x] 1.2 Add a small `install.sh` entrypoint that validates Bash, locates the repository root, and dispatches to `bin/ai-dev install`.
- [x] 1.3 Add `bin/ai-dev` command routing for `install`, `update`, `verify`, `doctor`, `list`, `status`, `enable`, `disable`, `remove`, `new`, and `reset`.
- [x] 1.4 Add CLI help, usage text, exit codes, and unknown-command handling.

## 2. Core Libraries

- [x] 2.1 Implement platform detection for OS, distribution, version, WSL2, architecture, shell, user, privilege state, and package manager.
- [x] 2.2 Implement logging helpers for command logs, error logs, timestamps, and final status records.
- [x] 2.3 Implement command execution helpers with dry-run support and clear failure reporting.
- [x] 2.4 Implement prompt helpers for confirmation, component selection, destructive-action confirmation, and non-interactive mode.
- [x] 2.5 Implement state helpers for reading, writing, and reconciling `state/installed.yaml` with real host checks.
- [x] 2.6 Implement security helpers for secret-safe file generation, Git-tracked secret avoidance, and permission checks.

## 3. Component Catalog And Planning

- [x] 3.1 Create `config/manifest.yaml` with initial component metadata, categories, dependencies, lifecycle module paths, supported platforms, credential flags, and context-cost flags.
- [x] 3.2 Create `config/profiles.yaml` for `developer`, `server`, `fullstack`, `ai`, `seo`, and `full`.
- [x] 3.3 Implement manifest validation with actionable errors for malformed components or missing modules.
- [x] 3.4 Implement dependency resolution for explicit components, profile selections, and interactive selections.
- [x] 3.5 Implement plan rendering that shows selected components, transitive dependencies, skipped installed components, unsupported components, required credentials, privileged actions, and destructive actions.
- [x] 3.6 Require user confirmation before executing install, update, remove, or reset plans.

## 4. Lifecycle Runtime

- [x] 4.1 Define the module contract and shared function names for `detect`, `install`, `configure`, `verify`, `update`, `remove`, and `doctor`.
- [x] 4.2 Implement runtime loading and invocation for component lifecycle modules.
- [x] 4.3 Implement idempotent install flow: detect, verify existing component, install missing pieces, configure safely, verify again, and update state.
- [x] 4.4 Implement update flow that updates selected components without forcing unrelated upgrades.
- [x] 4.5 Implement remove flow that preserves user data, configs, and Docker volumes unless explicitly confirmed.
- [x] 4.6 Implement `ai-dev verify` grouped by component category with final environment status.
- [x] 4.7 Implement `ai-dev doctor` diagnostics with suggested fixes for common failures.

## 5. Initial Modules

- [x] 5.1 Add system and package-manager modules for Ubuntu, Debian, and WSL2 Ubuntu.
- [x] 5.2 Add development tool modules for Git, GitHub CLI, Make, jq, yq, ripgrep, fd, and mise.
- [x] 5.3 Add Node.js/TypeScript module for Node.js, npm, pnpm, and TypeScript without global app frameworks by default.
- [x] 5.4 Add Python module for Python, pip, venv, uv, and Ruff without global web frameworks by default.
- [x] 5.5 Add PHP/Laravel module for PHP, Composer, Laravel Installer, and Laravel checks.
- [x] 5.6 Add Docker and Docker Compose modules for host Docker access and safe verification.
- [x] 5.7 Add infrastructure modules for PostgreSQL, Redis, optional MySQL/MariaDB, Traefik, and Portainer using Docker-safe defaults.
- [x] 5.8 Add security modules for Gitleaks, Trivy, and Semgrep.

## 6. AI, MCP, Agents, And Skills

- [x] 6.1 Research and document official install/configuration sources for OpenCode, OpenSpec, and each implemented MCP before coding those modules.
- [x] 6.2 Add OpenCode module with safe default permissions, config generation, and verification.
- [x] 6.3 Add OpenSpec module with config generation, workflow templates, and verification.
- [x] 6.4 Add selectable MCP modules for Context7, GitHub, Playwright, PostgreSQL, Sentry, Chrome DevTools, and Firecrawl.
- [x] 6.5 Ensure MCP modules prompt for required credentials securely and never write tokens to Git-tracked files.
- [x] 6.6 Add initial OpenCode skills for code review, security review, testing, Docker, database, frontend, backend, Laravel, Python, MCP setup, and SEO.
- [x] 6.7 Add AGENTS.md template covering workflow, OpenSpec use, MCP use, security, Git, tests, reviews, skills, agent behavior, and autonomy limits.

## 7. Project Scaffolding

- [x] 7.1 Implement `ai-dev new <name>` with stack selection and no-overwrite defaults.
- [x] 7.2 Add baseline templates for AGENTS.md, README.md, `.env.example`, `.gitignore`, OpenSpec, OpenCode, docs, tests, and optional Docker Compose.
- [x] 7.3 Add stack-aware scaffold variations for `node`, `python`, and `laravel`.
- [x] 7.4 Add project scaffold validation so generated projects contain expected files and no unresolved placeholders that should be filled automatically.

## 8. Tests And Quality

- [x] 8.1 Add shell linting configuration and make scripts shellcheck-compatible.
- [x] 8.2 Add automated tests for platform detection, manifest validation, dependency resolution, and plan rendering.
- [x] 8.3 Add automated tests for lifecycle idempotency using mocked component modules.
- [x] 8.4 Add automated tests for state reconciliation, verify output, doctor findings, and safe removal guards.
- [x] 8.5 Add scaffold tests for generated project structures.
- [x] 8.6 Add a CI workflow suitable for GitHub that runs linting and tests without modifying the host.

## 9. Documentation

- [x] 9.1 Add README instructions for cloning from GitHub and running the bootstrap.
- [x] 9.2 Document supported platforms, first-run flow, selective installation, profiles, direct component installs, verify, doctor, update, remove, and new project creation.
- [x] 9.3 Document safety model, secret handling, Docker defaults, destructive-action confirmations, and how state/log files work.
- [x] 9.4 Document how to add a new component by creating a module and registering it in the manifest.
- [x] 9.5 Document official source references used for each implemented integration.

## 10. Final Verification

- [x] 10.1 Run the full test suite and lint checks.
- [x] 10.2 Run `ai-dev list`, `ai-dev install --dry-run`, `ai-dev verify`, `ai-dev doctor`, and `ai-dev new` against a safe local/test fixture.
- [x] 10.3 Confirm all OpenSpec requirements have implementation coverage.
- [x] 10.4 Perform a security review for secrets, unsafe defaults, destructive actions, public service exposure, and unnecessary privileges.
