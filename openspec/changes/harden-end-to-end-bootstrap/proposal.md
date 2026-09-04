## Why

O rckit já oferece instalação remota, seleção de componentes e criação de projetos, mas parte do catálogo ainda declara sucesso com implementações genéricas ou verificações insuficientes. Antes de recomendar o uso em qualquer máquina, o projeto precisa garantir que cada opção anunciada funcione de ponta a ponta, que projetos gerados sejam completos e que os comandos publicados sejam validados em ambientes limpos.

## What Changes

- Auditar todos os componentes do manifesto e substituir instaladores, atualizações, remoções, configurações e verificações genéricas por comportamentos reais e idempotentes.
- Diferenciar ferramentas instaladas no host de serviços/configurações de projeto, impedindo que apenas a presença do Docker seja reportada como PostgreSQL, Redis, MySQL, Traefik ou Portainer instalado.
- Garantir que OpenCode, OpenSpec, ferramentas de segurança e MCPs sejam instalados e configurados pelos mecanismos oficiais, com versões e pré-requisitos verificáveis.
- Tornar o comando remoto único confiável para instalação interativa, perfis, componentes explícitos, dry-run e criação/atualização de projetos em qualquer diretório suportado.
- Instalar o comando `ai-dev` em um local utilizável pelo usuário e emitir orientação acionável quando o `PATH` precisar ser atualizado.
- Completar e validar os arquivos de projeto gerados, incluindo `AGENTS.md`, OpenCode, OpenSpec, skills, arquivos da stack, diretórios esperados e atualização preservando conteúdo existente.
- Corrigir documentação e exemplos para refletirem exatamente o comportamento automatizado, inclusive backup de configurações antigas e credenciais necessárias.
- Adicionar testes de contrato, integração e instalação limpa que bloqueiem a publicação quando houver placeholder, falso positivo de verificação, arquivo ausente ou comando documentado inválido.
- **BREAKING**: componentes sem implementação funcional serão implementados, reclassificados ou removidos do catálogo/perfis; `verify` deixará de considerar dependências genéricas como prova de que um serviço específico está pronto.

## Capabilities

### New Capabilities

- `component-installation-integrity`: Define instalação, configuração, atualização, remoção, idempotência e verificação reais para cada componente anunciado.
- `remote-command-reliability`: Define o comportamento do comando único distribuído pelo GitHub, incluindo TTY, seleção interativa, argumentos, atualização e disponibilidade de `ai-dev`.
- `generated-project-completeness`: Define a árvore completa e a atualização não destrutiva de projetos com OpenCode, OpenSpec, skills e arquivos de stack.
- `release-validation`: Define a auditoria automatizada de catálogo, templates, comandos documentados, ambientes limpos e publicação no GitHub.

### Modified Capabilities

Nenhuma capability principal existente está sincronizada em `openspec/specs/`; os contratos desta mudança serão introduzidos como novas capabilities e consolidados posteriormente.

## Impact

Serão afetados `remote-install.sh`, `install.sh`, `bin/ai-dev`, bibliotecas em `lib/`, todos os módulos em `modules/`, manifesto e perfis em `config/`, templates de OpenCode/OpenSpec/projeto, skills, testes, documentação e workflow de publicação no GitHub. A mudança pode adicionar dependências oficiais por componente e alterar o resultado de `install`, `update`, `verify`, `doctor`, `remove` e `new`, preservando secrets, configurações existentes e dados Docker.
