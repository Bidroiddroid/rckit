## ADDED Requirements

### Requirement: Criação oficial de projeto Astro
O sistema MUST permitir `ai-dev new <nome> --stack astro` e criar o projeto usando o gerador oficial do Astro, mantendo o nome e o destino fornecidos pelo usuário.

#### Scenario: Criar projeto Astro nomeado
- **WHEN** o usuário executa `ai-dev new portal --stack astro`
- **THEN** o sistema cria um projeto Astro válido em `portal/` e não usa `rckit` como nome do projeto

### Requirement: Runtime Astro compatível
O sistema MUST verificar antes da criação que Node.js atende ao mínimo oficial do Astro e pertence a uma linha par suportada.

#### Scenario: Node incompatível
- **WHEN** o usuário solicita a stack Astro com Node.js ausente, abaixo de 22.12.0 ou em uma linha ímpar não suportada
- **THEN** o sistema interrompe a criação com diagnóstico acionável e não declara o projeto concluído

### Requirement: Astro sem efeitos em dry-run
O sistema MUST representar no plano o gerador, a origem e o destino do projeto Astro sem acessar a rede nem escrever arquivos durante dry-run.

#### Scenario: Simular projeto Astro
- **WHEN** o usuário solicita a criação Astro com dry-run
- **THEN** o sistema mostra as ações oficiais planejadas e deixa o destino inalterado

### Requirement: Projeto Astro verificável
O sistema MUST considerar a criação concluída somente quando os arquivos essenciais do Astro existirem e os comandos de instalação e build puderem ser validados no ambiente de teste aplicável.

#### Scenario: Gerador termina sem estrutura válida
- **WHEN** o gerador retorna sem produzir uma configuração e uma página Astro reconhecíveis
- **THEN** o sistema retorna falha e orienta como inspecionar ou reparar o destino
