# Official Sources

Estas fontes oficiais foram revisadas em 2026-09-05. Instaladores e schemas externos podem mudar e devem ser conferidos antes de alterar os módulos.

- OpenCode estável: https://opencode.ai/en/docs (instalação `npm install -g opencode-ai`, binário `opencode`). A configuração desta versão mantém servidores diretamente em `mcp`. OpenCode v2 permanece beta, instala `opencode2` e usa `mcp.servers`; os schemas não são misturados.
- OpenSpec: https://github.com/Fission-AI/OpenSpec/blob/main/docs/installation.md (`npm install -g @fission-ai/openspec@latest`, Node.js 20.19.0+).
- mise: https://mise.jdx.dev/installing-mise.html (instalador Linux preferido em `https://mise.run`, destino padrão `~/.local/bin/mise`).
- uv/Ruff: https://docs.astral.sh/uv/getting-started/installation/ e https://docs.astral.sh/ruff/installation/.
- Docker Engine: https://docs.docker.com/engine/install/ e Compose: https://docs.docker.com/compose/install/linux/.
- Gitleaks: https://github.com/gitleaks/gitleaks; Trivy: https://trivy.dev/latest/getting-started/installation/; Semgrep: https://semgrep.dev/docs/getting-started/.
- Astro: https://docs.astro.build/en/install-and-setup/ (`npm create astro@latest`; Node.js 22.12.0+ em versão par suportada; instalação local no projeto).
- skills.sh CLI: https://github.com/vercel-labs/skills (`npx skills`) e coleção Vercel: https://github.com/vercel-labs/agent-skills (`npx skills add vercel-labs/agent-skills`). skills.sh é o diretório/ecossistema, não uma skill individual.

## AI Tooling

- OpenCode install and v2 beta note: https://opencode.ai/v2/docs
- OpenCode permissions: https://opencode.ai/docs/permissions/
- OpenCode config: https://dev.opencode.ai/docs/config/
- OpenCode v2 config: https://opencode.ai/v2/docs/config
- OpenSpec CLI: https://openspec.dev/docs/cli

## MCP Integrations

- Context7 MCP clients: https://context7.com/docs/resources/all-clients
- GitHub MCP Server: https://github.com/github/github-mcp-server
- Playwright MCP: https://playwright.dev/docs/getting-started-mcp
- PostgreSQL MCP usage: https://github.com/microsoft/postgres-mcp/blob/main/USAGE.md
- Sentry MCP: https://github.com/getsentry/sentry-mcp
- Chrome DevTools for agents: https://developer.chrome.com/docs/devtools/agents/get-started
- Chrome DevTools MCP repository: https://github.com/ChromeDevTools/chrome-devtools-mcp
- Firecrawl MCP server: https://docs.firecrawl.dev/ai-onboarding

## Module Hardening Notes

- OpenCode v2 currently installs as `opencode2` and does not replace the v1 `opencode` binary.
- OpenCode v1 permission config uses `permission`; OpenCode v2 uses `permissions` rule arrays. The current template uses conservative v1-compatible approval defaults until the project chooses a target OpenCode major version.
- OpenCode MCP servers add context and should remain opt-in.
- GitHub MCP is configured in remote mode and reads `GITHUB_PERSONAL_ACCESS_TOKEN` from the environment; tokens must never be written to tracked files.
- Playwright MCP requires Node.js 20 or newer.
- Chrome DevTools MCP exposes browser content to the agent and must remain opt-in.
- Firecrawl MCP requires `FIRECRAWL_API_KEY` for local execution.
- MCP module verification must check the concrete runtime needed by the configured server, not only the presence of OpenCode.
- MCP config fragments live under `templates/opencode/mcp/` and are merged into `mcp.<server-name>` in the user's OpenCode config only when that MCP is selected.
