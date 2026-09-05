## ADDED Requirements

### Requirement: Catálogo sem instalação simulada
Cada componente publicado no manifesto MUST possuir operações reais para seu tipo operacional ou MUST ser removido/reclassificado; nenhuma operação ausente pode terminar com sucesso usando placeholder.

#### Scenario: Auditoria encontra módulo genérico incompleto
- **WHEN** a validação examina um componente que depende de fallback sem efeito real
- **THEN** a validação falha e identifica o componente e a operação ausente

### Requirement: Verificação específica por componente
O comando `verify` MUST comprovar o resultado próprio do componente, incluindo versão mínima, configuração ou health check aplicável, e MUST retornar falha para falsos positivos.

#### Scenario: Docker existe sem PostgreSQL provisionado
- **WHEN** o usuário verifica PostgreSQL e somente o binário Docker está disponível
- **THEN** PostgreSQL é reportado como não configurado ou indisponível

### Requirement: Lifecycle idempotente e seguro
Instalação e atualização MUST poder ser repetidas sem corromper estado; remoção MUST preservar configurações, projetos e volumes salvo confirmação destrutiva explícita.

#### Scenario: Componente já está corretamente instalado
- **WHEN** o usuário solicita novamente sua instalação
- **THEN** o componente é validado e a operação termina sem reinstalação desnecessária

### Requirement: Credenciais fora do repositório
Componentes autenticados MUST informar a credencial ou fluxo OAuth necessário e MUST NOT gravar secrets em arquivos versionados ou logs.

#### Scenario: MCP exige token ausente
- **WHEN** a configuração estrutural existe mas a credencial necessária não está disponível
- **THEN** `doctor` informa a variável ou autorização pendente sem exibir qualquer secret
