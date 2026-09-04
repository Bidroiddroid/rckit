## ADDED Requirements

### Requirement: Nome e destino independentes do rckit
O scaffold MUST usar o nome fornecido ou o nome da pasta atual e MUST NOT nomear o projeto como `rckit` implicitamente.

#### Scenario: Projeto criado na pasta atual
- **WHEN** o usuário executa `--new . --stack node` dentro de `meu-sistema`
- **THEN** os templates usam `meu-sistema` como nome do projeto

### Requirement: Árvore completa de IA e stack
O scaffold MUST criar `AGENTS.md`, README, ambiente, ignore, Compose da stack, configuração OpenCode válida, skills completas e OpenSpec com `config.yaml`, README, `changes/` e `specs/`.

#### Scenario: Projeto Node novo
- **WHEN** um projeto Node é criado em diretório vazio
- **THEN** todos os arquivos e diretórios obrigatórios existem e passam nas validações JSON/YAML e de conteúdo

### Requirement: Atualização conservadora de projeto existente
Ao executar `--new .` em projeto existente, o scaffold MUST criar itens ausentes, MUST preservar arquivos personalizados e MUST fazer backup antes de substituir configuração antiga reconhecida.

#### Scenario: Configuração OpenSpec antiga e arquivo personalizado
- **WHEN** o projeto contém um `openspec/config.yaml` mínimo antigo e um README personalizado
- **THEN** a configuração antiga recebe backup, a completa é criada e o README permanece inalterado

### Requirement: Templates sem secrets e com dados reais
Arquivos gerados MUST usar placeholders somente para secrets, MUST conter o nome real do projeto e MUST incluir as regras e armadilhas definidas no template OpenSpec.

#### Scenario: Inspeção do projeto gerado
- **WHEN** os templates gerados são auditados
- **THEN** nenhum token real é encontrado e `config.yaml` contém `schema: spec-driven`, regras e conhecimento preservado
