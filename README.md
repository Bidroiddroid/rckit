# AI DEV BOOTSTRAP

O rckit prepara máquinas Ubuntu, Debian e WSL2 Ubuntu e cria projetos com somente os componentes escolhidos. `rckit` é o nome da ferramenta; cada sistema gerado recebe o nome informado por você.

## Instalação com um comando

Para abrir a seleção por caixas marcáveis:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s --
```

Use setas e Espaço para marcar `[x]`, ou clique quando o terminal oferecer suporte a mouse. Enter confirma. A instalação pode pedir a senha do `sudo` para pacotes do sistema.

Para revisar um perfil sem alterar o ambiente:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --profile developer --dry-run
```

Para instalar um componente específico:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- python
```

## Criar um projeto

Criar uma pasta com o nome escolhido:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --new meu-projeto --stack node
```

Criar ou completar os arquivos dentro da pasta atual:

```bash
wget -O- https://raw.githubusercontent.com/Bidroiddroid/rckit/main/remote-install.sh | bash -s -- --new . --stack node
```

Stacks disponíveis: `node`, `python` e `laravel`. Arquivos personalizados são preservados. Configurações antigas reconhecidas recebem backup `.old.<data>` antes da regeneração.

O projeto inclui `AGENTS.md`, `opencode.json` na raiz, skills em `.opencode/skills/`, comandos oficiais em `.opencode/commands/`, `openspec/config.yaml`, `openspec/changes/archive/`, `openspec/specs/`, README, `.env.example`, `.gitignore`, testes e Compose da stack.

Para OpenCode, o scaffold instala o conjunto oficial core do OpenSpec com entrega `both`: `openspec-propose`, `openspec-explore`, `openspec-apply-change`, `openspec-archive-change` e os comandos correspondentes `opsx-propose`, `opsx-explore`, `opsx-apply` e `opsx-archive`. As skills adicionais do fluxo expandido também permanecem disponíveis.

## Comando local

O instalador mantém o bootstrap em `~/.local/share/rckit` e cria `~/.local/bin/ai-dev`. Se necessário, habilite esse diretório na sessão:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Comandos principais:

```bash
ai-dev list
ai-dev install python --dry-run
ai-dev install --profile ai --dry-run
ai-dev verify
ai-dev doctor
ai-dev new meu-projeto --stack node
```

Use `RCKIT_INSTALL_DIR` para mudar o clone local e `RCKIT_REPO_URL` para testar outro remote.

## Perfis

- `developer`: Git, GitHub CLI, Make, jq, yq, ripgrep, fd e mise.
- `server`: Docker, Compose e configurações locais de Traefik, Portainer, PostgreSQL e Redis.
- `fullstack`: Node, Python, PHP/Laravel, Docker, PostgreSQL e Redis.
- `ai`: OpenCode estável, OpenSpec, Context7, GitHub MCP e Playwright MCP.
- `seo`: Node, Python e Firecrawl MCP.
- `full`: conjunto amplo; revise com `--dry-run` antes de instalar.

PostgreSQL, Redis, MySQL, Traefik e Portainer criam arquivos em `~/.config/rckit/services/<componente>/compose.yml`. Eles não são iniciados automaticamente. O comando exato para iniciar aparece em `ai-dev doctor <componente>`.

## MCPs e credenciais

MCPs são opcionais e são mesclados em `~/.config/opencode/opencode.json`, preservando as outras chaves.

- Sem credencial: Context7 e Playwright. Chrome DevTools também não usa credencial, mas exige Chrome/Chromium.
- `mcp-github`: `GITHUB_PERSONAL_ACCESS_TOKEN`.
- `mcp-postgresql`: `DATABASE_URL`.
- `mcp-firecrawl`: `FIRECRAWL_API_KEY`.
- `mcp-sentry`: autorização OAuth no primeiro uso.

```bash
ai-dev doctor mcp-context7 mcp-playwright mcp-chrome-devtools
ai-dev doctor mcp-github mcp-postgresql mcp-sentry mcp-firecrawl
```

Tokens nunca são gravados pelo rckit em arquivos versionados ou logs.

## Segurança e limites

`--dry-run` não instala pacotes nem grava configuração, estado persistente ou projeto. Remoções pedem confirmação e preservam projetos, credenciais e volumes Docker. O acesso à rede, disponibilidade de repositórios oficiais, autenticação externa e reinício da sessão para grupos/PATH continuam dependências da máquina.

Consulte [componentes](docs/components.md), [inventário verificável](docs/component-inventory.md), [fontes oficiais](docs/official-sources.md) e [segurança](docs/safety.md).

## Desenvolvimento

```bash
tests/audit.sh
tests/contracts.sh
tests/smoke.sh
tests/integration.sh
```
