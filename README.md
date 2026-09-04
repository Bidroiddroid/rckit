# AI DEV BOOTSTRAP

AI DEV BOOTSTRAP is a GitHub-friendly bootstrap repository for preparing a new development machine or starting a new system with only the tools you choose.

It is designed for Ubuntu, Debian, and WSL2 Ubuntu first. The first implementation is shell-first, modular, and manifest-driven so new tools can be added without rewriting the CLI.

## Quick Start

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- --profile developer --dry-run
```

Use `--dry-run` first to review what would happen. Remove it only after reviewing the plan.

The repository folder is only the bootstrap tool. Your project name is chosen separately when you create a project:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- --new meu-projeto --stack node
```

The one-line installer stores the bootstrap repository at `~/.local/share/rckit` by default. Change that location with `RCKIT_INSTALL_DIR`.

## Install From GitHub

On any supported machine:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" --
```

The bootstrap folder is not the generated project name. Project names are passed to `--new`.

To install only one component:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- python --dry-run
```

To use a profile:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- --profile ai --dry-run
```

## Common Commands

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- --profile developer --dry-run
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- python --dry-run
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- --profile ai --dry-run
bash -c "$(wget -qO- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh)" -- --new meu-projeto --stack node
```

## Profiles

- `developer`: Git, GitHub CLI, Make, jq, yq, ripgrep, fd, mise.
- `server`: Docker, Compose, Traefik, Portainer, PostgreSQL, Redis.
- `fullstack`: Node.js, Python, PHP/Laravel, Docker, PostgreSQL, Redis.
- `ai`: OpenCode, OpenSpec, and selected MCPs.
- `seo`: Node/Python plus optional crawler-oriented tooling.
- `full`: broad development environment.

Profiles are shortcuts. You can always install one component at a time.

## Safety

The tool shows a plan before changes, keeps MCPs opt-in, avoids writing secrets to tracked files, and preserves Docker volumes and existing configuration unless you explicitly confirm a destructive action.
