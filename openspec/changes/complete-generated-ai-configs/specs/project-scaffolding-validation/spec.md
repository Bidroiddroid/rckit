## ADDED Requirements

### Requirement: Validação de scaffold completo
O sistema MUST validar que projetos gerados possuem arquivos úteis de OpenSpec, OpenCode, agentes, README, ambiente e Docker Compose quando aplicável.

#### Scenario: Scaffold node validado
- **WHEN** os testes executam `ai-dev new sample --stack node --yes`
- **THEN** o projeto gerado MUST conter `AGENTS.md`, `README.md`, `.env.example`, `.gitignore`, `docker-compose.yml`, `.opencode/opencode.json` e `openspec/config.yaml` completos.

### Requirement: Sem placeholders não resolvidos
O sistema MUST substituir placeholders obrigatórios em todos os arquivos gerados.

#### Scenario: Projeto gerado sem placeholders
- **WHEN** os testes inspecionam um projeto gerado
- **THEN** nenhum arquivo MUST conter `{{PROJECT_NAME}}`.

### Requirement: Atualização segura de projeto existente
O sistema MUST permitir rodar `ai-dev new . --stack <stack>` em uma pasta existente para escrever arquivos faltantes sem sobrescrever arquivos existentes silenciosamente.

#### Scenario: Criar arquivos na pasta atual
- **WHEN** o usuário executa `ai-dev new . --stack node --yes` em uma pasta existente
- **THEN** o sistema MUST criar arquivos faltantes do scaffold na pasta atual e MUST preservar arquivos já existentes.
