# Official Sources

These sources were checked before adding the initial AI and MCP module placeholders. Real installer hardening must re-check these pages because install commands and configuration schemas can change.

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
