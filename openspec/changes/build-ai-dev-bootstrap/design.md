## Context

AI DEV BOOTSTRAP will be a reusable GitHub-hosted project that a developer can clone or download when preparing a new machine or starting a new system. The first implementation targets Ubuntu, Debian, and WSL2 Ubuntu, and must remain small enough to run on a mostly clean machine while still providing a maintainable architecture for future operating systems, languages, frameworks, MCPs, and services.

The repository currently contains OpenSpec configuration and the source prompt. There is no existing application code, so this change defines the initial product architecture, contracts, and implementation plan.

## Goals / Non-Goals

**Goals:**

- Provide a repository entrypoint that launches AI DEV BOOTSTRAP from a fresh clone.
- Provide an `ai-dev` CLI with interactive and direct commands.
- Let the user install only selected components, either individually, via profile, or from an interactive menu.
- Resolve required dependencies automatically before installing selected components.
- Keep modules idempotent, observable, and safe to re-run.
- Preserve existing installations, configuration, secrets, Docker volumes, project files, and shell configuration unless the user confirms an overwrite or destructive action.
- Prepare OpenCode + OpenSpec as the primary AI development workflow.
- Track state and logs while validating the real host on every operation.
- Make adding a future component mostly a matter of adding a module and manifest entry.

**Non-Goals:**

- Do not install every supported tool by default.
- Do not enable every MCP globally.
- Do not replace project-specific setup with a single global Docker stack.
- Do not support every operating system in the first version.
- Do not hardcode user secrets, API tokens, database passwords, or OAuth credentials.
- Do not build a package manager replacement; delegate installs to official package managers or official upstream methods.

## Decisions

### Use a shell-first core with strict module contracts

The first version will use Bash for the bootstrap entrypoint, shared libraries, and component modules because clean Ubuntu/Debian/WSL2 systems already provide Bash and POSIX tooling. This minimizes prerequisites before the tool can install richer dependencies.

Alternatives considered:

- Go or Rust CLI: stronger distribution story, but requires bootstrapping a binary build/release workflow before the first version is useful.
- Node or Python CLI: better libraries, but introduces language runtime prerequisites before the bootstrap can run.

The Bash core must be organized as modules and shared libraries, not as one large script. A future compiled CLI can wrap or replace the shell core without changing the manifest and module contract.

### Keep the repository as the distribution artifact

The primary install path is:

1. Clone or download the GitHub repository.
2. Run a small entrypoint such as `./install.sh` or `./bin/ai-dev install`.
3. Select components from an interactive menu or pass explicit component/profile arguments.

The entrypoint only validates prerequisites, loads libraries, and dispatches to the CLI. Long-term logic lives in `lib/`, `modules/`, `config/`, and `templates/`.

### Drive behavior from a declarative manifest

`config/manifest.yaml` will define components, categories, dependencies, supported platforms, install methods, lifecycle module paths, default enabled state, whether credentials are required, and whether the component consumes AI-agent context.

`config/profiles.yaml` will define convenience selections such as `developer`, `server`, `fullstack`, `ai`, `seo`, and `full`. Profiles expand into components but never prevent manual component selection.

The resolver will produce an installation plan from requested components and profiles, including transitive dependencies, conflicts, unsupported components, credential prompts, and confirmation steps.

### Separate lifecycle operations per component

Each module exposes the same lifecycle functions or command files:

- `detect`: inspect current host state.
- `install`: install missing component requirements.
- `configure`: apply safe configuration.
- `verify`: prove the component works.
- `update`: update when requested.
- `remove`: remove only the component-owned installation or configuration after confirmation.
- `doctor`: diagnose common problems and suggest fixes.

Modules must not trust `state/installed.yaml` alone. State is a cache/audit record and must be reconciled with real commands such as version checks, file existence checks, service health checks, and Docker inspections.

### Prefer official installation sources

Implementation of each integration must record official source references in project documentation before shipping that module. The module should prefer official package repositories, official install scripts, official release artifacts, or documented package manager flows.

### Treat Docker as infrastructure, not the universal runtime

Development CLIs such as Git, Node.js, Python, PHP, Composer, OpenCode, OpenSpec, and helper tools run on the host when selected. Docker is used for project services and infrastructure such as PostgreSQL, Redis, MySQL/MariaDB, Traefik, Portainer, and per-project stacks.

### Make secrets explicit and local

Secrets must be requested only when needed, stored outside Git-tracked files, and represented in templates through `.env.example` placeholders. MCP modules requiring credentials must configure the minimum required scope and document how to rotate or revoke credentials.

### Build verification and diagnostics as first-class commands

`ai-dev verify` returns pass/fail status for selected or installed components. `ai-dev doctor` diagnoses known host problems such as missing PATH entries, Docker daemon failures, invalid MCP config, unavailable databases, missing credentials, and permission issues. Both commands are useful after initial install and during maintenance.

## Risks / Trade-offs

- Bash can become hard to maintain as behavior grows -> enforce module boundaries, shellcheck-compatible style, Bats tests, and small shared libraries.
- Official install methods change over time -> keep source-reference docs and isolate installer commands inside component modules.
- Running installers on host machines can be risky -> require plan review, confirmations for privileged or destructive actions, dry-run support, and no overwrite by default.
- Interactive CLIs vary across environments -> support direct non-interactive commands and degrade gracefully if optional UI helpers are unavailable.
- Docker services can expose sensitive ports -> bind local by default, avoid public admin dashboards, and require explicit confirmation for exposed services.
- MCPs can consume context or require broad permissions -> keep MCPs opt-in, surface permission scopes, and never enable all MCPs globally.
