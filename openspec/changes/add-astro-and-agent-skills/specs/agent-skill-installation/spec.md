## ADDED Requirements

### Requirement: Instalação opt-in da coleção Vercel
O sistema MUST oferecer `agent-skills` como componente não selecionado por padrão que instala `vercel-labs/agent-skills` por meio do CLI oficial do ecossistema skills.sh no projeto alvo.

#### Scenario: Selecionar agent skills
- **WHEN** o usuário seleciona explicitamente `agent-skills` em um projeto válido
- **THEN** o plano identifica `vercel-labs/agent-skills`, suas dependências, o destino e o custo de contexto antes da instalação

### Requirement: Skills existentes preservadas
O sistema MUST preservar skills e configurações existentes que não sejam comprovadamente gerenciadas pelo componente.

#### Scenario: Projeto possui skill personalizada
- **WHEN** a coleção é instalada em um projeto que já contém uma skill personalizada
- **THEN** o sistema mantém a skill personalizada e não a substitui silenciosamente

### Requirement: Lifecycle real das agent skills
O sistema MUST implementar instalação, atualização, verificação, diagnóstico e remoção conservadora com base na estrutura real instalada, sem confiar somente no estado do rckit.

#### Scenario: Estado afirma instalação mas arquivos não existem
- **WHEN** o estado local registra `agent-skills` e os arquivos esperados não estão presentes
- **THEN** verify informa falha e doctor apresenta recuperação acionável

#### Scenario: Remoção encontra propriedade ambígua
- **WHEN** remove não consegue distinguir arquivos da coleção de arquivos do usuário
- **THEN** o sistema preserva os arquivos e recusa remoção destrutiva automática

### Requirement: Execução segura e sem credenciais obrigatórias
O sistema MUST executar o instalador sem privilégios, não armazenar credenciais e não realizar download ou escrita durante dry-run.

#### Scenario: Simular instalação da coleção
- **WHEN** o usuário seleciona `agent-skills` com `--dry-run`
- **THEN** o sistema mostra a origem e o comando planejado sem executar `npx`, acessar GitHub/npm ou modificar o projeto

#### Scenario: Serviço externo indisponível
- **WHEN** npm, GitHub ou o CLI oficial falha durante a instalação
- **THEN** o sistema retorna código de erro diferente de zero e não registra falso sucesso
