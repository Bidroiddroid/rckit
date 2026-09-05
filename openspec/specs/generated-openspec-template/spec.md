# generated-openspec-template Specification

## Purpose
TBD - created by archiving change complete-generated-ai-configs. Update Purpose after archive.
## Requirements
### Requirement: Template OpenSpec completo para projetos gerados
O sistema MUST gerar `openspec/config.yaml` completo em novos projetos, preservando contexto, arquitetura, convenções, módulos, regras e observações importantes em português.

#### Scenario: Novo projeto recebe OpenSpec completo
- **WHEN** o usuário executa `ai-dev new meu-projeto --stack node`
- **THEN** o arquivo `meu-projeto/openspec/config.yaml` MUST conter `schema: spec-driven`, contexto em português, regras de proposal/design/specs/tasks e seção de conhecimento caro.

### Requirement: Nome de projeto dinâmico no OpenSpec
O sistema MUST substituir `{{PROJECT_NAME}}` pelo nome real do projeto gerado no template OpenSpec.

#### Scenario: Scaffold em subpasta usa nome informado
- **WHEN** o usuário executa `ai-dev new sistema-vendas --stack node`
- **THEN** `sistema-vendas/openspec/config.yaml` MUST conter `sistema-vendas` e MUST NOT conter `{{PROJECT_NAME}}`.

#### Scenario: Scaffold na pasta atual usa nome da pasta
- **WHEN** o usuário executa `ai-dev new . --stack node` dentro da pasta `roberto`
- **THEN** `openspec/config.yaml` MUST conter `roberto` e MUST NOT conter `{{PROJECT_NAME}}`.

### Requirement: Template OpenSpec orientado por dados reais
O sistema MUST evitar um `config.yaml` genérico ou mínimo em projetos gerados e MUST incluir as convenções e armadilhas já aprendidas durante a construção do rckit.

#### Scenario: Regressão para config mínimo
- **WHEN** os testes do scaffold verificam `templates/openspec/config.yaml`
- **THEN** os testes MUST falhar se o arquivo contiver apenas chaves mínimas como `version` e `project`.
