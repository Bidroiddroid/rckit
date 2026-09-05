# Inventário de componentes

Este arquivo define o resultado verificável de cada opção publicada. `host` instala uma CLI ou pacote; `mcp` configura um servidor no OpenCode estável; `service` cria um Compose em `~/.config/rckit/services/<id>/compose.yml` sem iniciá-lo automaticamente.

| Componentes | Tipo | Instalação | Verificação |
| --- | --- | --- | --- |
| system | host | plataforma existente | Ubuntu/Debian/WSL2 Ubuntu |
| git, github-cli, make, jq, yq, ripgrep, fd | host | apt | comando específico; GitHub auth no doctor |
| mise | host | instalador oficial mise.run | `mise --version`/`mise doctor` |
| node | host | mise `node@22` | Node >=22.12 em versão par, npm, pnpm e tsc |
| python | host | apt + uv oficial | python3, pip3, uv e Ruff |
| php | host | apt | PHP e Composer |
| laravel | host | Composer global | comando `laravel` |
| astro | framework/projeto | `npm create astro@latest` | Node compatível; `package.json` e `src/pages/index.astro` no projeto gerado |
| agent-skills | integração IA de projeto | `npx skills add vercel-labs/agent-skills` | fonte em `skills-lock.json` e `.agents/skills/*/SKILL.md` |
| docker, compose | host | apt | daemon Docker e `docker compose version` |
| postgresql, redis, mysql, traefik, portainer | service | template Compose local | arquivo próprio aceito por `docker compose config` |
| opencode | host | npm `opencode-ai` estável | comando `opencode` e JSON no doctor |
| openspec | host | npm `@fission-ai/openspec` | CLI e Node >=20.19 |
| mcp-context7, mcp-github, mcp-playwright, mcp-postgresql, mcp-sentry, mcp-chrome-devtools, mcp-firecrawl | mcp | merge no OpenCode | entrada própria, runtime e credencial quando aplicável |
| gitleaks, trivy | host | releases via mise | comando específico |
| semgrep | host | ambiente isolado `uv tool` | comando `semgrep` |

Os métodos oficiais e limitações revisados ficam em `docs/official-sources.md`.
