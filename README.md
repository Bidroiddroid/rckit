# AI DEV BOOTSTRAP

AI DEV BOOTSTRAP is a GitHub-friendly bootstrap repository for preparing a new development machine or starting a new system with only the tools you choose.

It is designed for Ubuntu, Debian, and WSL2 Ubuntu first. The first implementation is shell-first, modular, and manifest-driven so new tools can be added without rewriting the CLI.

## Quick Start

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/Bidroiddroid/rckit.git ai-dev-bootstrap
cd ai-dev-bootstrap
chmod +x install.sh bin/ai-dev
./install.sh --profile developer --dry-run
```

Use `--dry-run` first to review what would happen. Remove it only after reviewing the plan.

The repository folder is only the bootstrap tool. Your project name is chosen separately when you create a project:

```bash
./install.sh --new meu-projeto --stack node
```

## Install From GitHub

On any supported machine:

```bash
git clone https://github.com/Bidroiddroid/rckit.git ai-dev-bootstrap
cd ai-dev-bootstrap
chmod +x install.sh bin/ai-dev
./install.sh
```

You can change `ai-dev-bootstrap` to any local folder name. That folder is not the generated project name.

To install only one component:

```bash
./install.sh python --dry-run
```

To use a profile:

```bash
./install.sh --profile ai --dry-run
```

## Common Commands

```bash
bin/ai-dev list
bin/ai-dev install python --dry-run
bin/ai-dev install --profile ai --dry-run
bin/ai-dev verify
bin/ai-dev doctor
bin/ai-dev new meu-projeto --stack node
./install.sh --new meu-projeto --stack laravel
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
