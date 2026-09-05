# release-validation Specification

## Purpose
TBD - created by archiving change harden-end-to-end-bootstrap. Update Purpose after archive.
## Requirements
### Requirement: Testes rápidos obrigatórios
Antes da publicação, o projeto MUST executar validação de sintaxe Bash, contratos, smoke tests, parsing JSON/YAML e auditoria de placeholders para todo componente publicado.

#### Scenario: Módulo sem instalador real
- **WHEN** um componente novo é adicionado com fallback sem efeito
- **THEN** a suíte falha antes do push e informa o módulo inválido

### Requirement: Validação em ambiente limpo
Os fluxos críticos MUST ser testados em ambientes limpos representativos de Ubuntu/Debian, incluindo instalação remota simulada, idempotência, PATH e scaffold novo/legado.

#### Scenario: Execução em ambiente limpo
- **WHEN** a matriz de integração instala um perfil suportado duas vezes
- **THEN** ambas as execuções terminam corretamente e a segunda não corrompe nem duplica configuração

### Requirement: Comandos documentados executáveis
Os comandos principais do README MUST corresponder à CLI atual e MUST ser cobertos por teste ou extraídos de uma fonte única validada.

#### Scenario: Exemplo fica incompatível
- **WHEN** uma opção da CLI muda sem atualização do README
- **THEN** a validação de documentação falha antes da publicação

### Requirement: Publicação e verificação do GitHub
O deploy MUST publicar commits na branch `main` sem sobrescrever histórico remoto e MUST validar o arquivo raw e ao menos um fluxo público após o push.

#### Scenario: Release publicada
- **WHEN** os testes locais e limpos passam e o commit é enviado ao GitHub
- **THEN** o instalador raw retorna sucesso e o comando público gera o resultado esperado em diretório temporário

### Requirement: Testes independentes dos componentes instalados pelo bootstrap
A suíte de CI MUST executar em um runner mínimo sem exigir previamente ferramentas opcionais que o próprio rckit oferece como componentes.

#### Scenario: Runner sem ripgrep
- **WHEN** o job de smoke inicia sem o comando `rg`
- **THEN** auditoria, contratos e integração executam usando ferramentas base e não falham com `command not found`
