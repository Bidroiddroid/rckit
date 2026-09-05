# generated-opencode-template Specification

## Purpose
TBD - created by archiving change complete-generated-ai-configs. Update Purpose after archive.
## Requirements
### Requirement: Template OpenCode completo e seguro
O sistema MUST gerar `.opencode/opencode.json` válido, com permissões conservadoras, leitura permitida, escrita e shell sujeitos a aprovação e MCPs vazios por padrão.

#### Scenario: Novo projeto recebe OpenCode seguro
- **WHEN** o usuário executa `ai-dev new meu-projeto --stack node`
- **THEN** `.opencode/opencode.json` MUST ser JSON válido e MUST NOT conceder permissão irrestrita para edição ou execução shell.

### Requirement: MCPs opt-in no projeto gerado
O sistema MUST manter o template OpenCode base sem MCPs ativos por padrão, enquanto permite que MCPs selecionados sejam adicionados pelo fluxo de instalação/configuração.

#### Scenario: Projeto base não ativa todos os MCPs
- **WHEN** o usuário cria um projeto novo sem selecionar MCPs
- **THEN** `.opencode/opencode.json` MUST conter uma seção `mcp` vazia ou equivalente seguro e MUST NOT conter tokens ou todos os MCPs pré-ativados.

### Requirement: Configuração sem secrets
O sistema MUST NOT gravar tokens, URLs com senha ou credenciais reais em templates OpenCode.

#### Scenario: Verificação de secrets nos templates
- **WHEN** os testes analisam `templates/opencode/opencode.json` e `templates/opencode/mcp/*.json`
- **THEN** eles MUST aceitar somente placeholders de ambiente e MUST falhar se encontrarem valores reais de credenciais.
