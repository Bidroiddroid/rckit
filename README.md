# AI DEV BOOTSTRAP

AI DEV BOOTSTRAP is a GitHub-friendly bootstrap repository for preparing a new development machine or starting a new system with only the tools you choose.

It is designed for Ubuntu, Debian, and WSL2 Ubuntu first. The first implementation is shell-first, modular, and manifest-driven so new tools can be added without rewriting the CLI.

## Quick Start

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --profile developer --dry-run
```

Use `--dry-run` first to review what would happen. Remove it only after reviewing the plan.

The repository folder is only the bootstrap tool. Your project name is chosen separately when you create a project:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --new meu-projeto --stack node
```

The one-line installer stores the bootstrap repository at `~/.local/share/rckit` by default. Change that location with `RCKIT_INSTALL_DIR`.

## Install From GitHub

On any supported machine:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s --
```

Running without components or `--profile` opens the interactive component selection. If `dialog` is available, you can click the checkbox with the mouse; Space also marks `[x]`, and Enter continues.

The bootstrap folder is not the generated project name. Project names are passed to `--new`.

If the command returns to the prompt without output, test the download directly:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh
```

To install only one component:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- python --dry-run
```

To use a profile:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --profile ai --dry-run
```

## Common Commands

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --profile developer --dry-run
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- python --dry-run
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --profile ai --dry-run
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --new meu-projeto --stack node
```

## Profiles

- `developer`: Git, GitHub CLI, Make, jq, yq, ripgrep, fd, mise.
- `server`: Docker, Compose, Traefik, Portainer, PostgreSQL, Redis.
- `fullstack`: Node.js, Python, PHP/Laravel, Docker, PostgreSQL, Redis.
- `ai`: OpenCode, OpenSpec, and selected MCPs.
- `seo`: Node/Python plus optional crawler-oriented tooling.
- `full`: broad development environment.

Profiles are shortcuts. You can always install one component at a time.

## MCPs

MCP components are opt-in. When selected, the installer merges the selected server into:

```bash
~/.config/opencode/opencode.json -> mcp.<server-name>
```

Remote MCPs such as Context7, GitHub, and Sentry do not require local `npx`. Local MCPs such as Playwright, PostgreSQL, Chrome DevTools, and Firecrawl use `npx` and require Node.js. MCPs with external credentials read tokens from environment variables instead of tracked files:

```bash
export GITHUB_PERSONAL_ACCESS_TOKEN=...
export DATABASE_URL=...
export FIRECRAWL_API_KEY=...
```

Run `ai-dev doctor mcp-github mcp-postgresql mcp-firecrawl` after configuring credentials.

## Safety

The tool shows a plan before changes, keeps MCPs opt-in, avoids writing secrets to tracked files, and preserves Docker volumes and existing configuration unless you explicitly confirm a destructive action.
