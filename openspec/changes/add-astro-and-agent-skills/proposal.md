## Why

O rckit ainda não permite selecionar Astro ao criar um projeto e não oferece um fluxo integrado para adicionar coleções de skills do ecossistema skills.sh. Isso obriga o usuário a executar instalações manuais depois do bootstrap e reduz a repetibilidade do ambiente de agentes.

## What Changes

- Adicionar Astro como stack selecionável na criação de projetos, com pré-requisito compatível de Node.js e uso do gerador oficial.
- Adicionar um componente opt-in para instalar o CLI/ecossistema skills.sh e a coleção `vercel-labs/agent-skills` em projetos gerados ou existentes.
- Preservar skills já existentes, exigir seleção explícita e representar corretamente instalação, dry-run, verificação, atualização e diagnóstico.
- Atualizar catálogo, perfis aplicáveis, ajuda da CLI, documentação e testes para os novos fluxos.
- Módulos afetados: catálogo de componentes, módulo Node.js, scaffolding de projetos, templates, runtime de lifecycle, documentação e testes.
- Não há BREAKING CHANGES: stacks e componentes existentes permanecem compatíveis.

## Capabilities

### New Capabilities

- `astro-project-stack`: criação e validação de projetos Astro pelo fluxo oficial, mantendo o nome e o destino escolhidos pelo usuário.
- `agent-skill-installation`: instalação opt-in, segura e verificável de skills do skills.sh, incluindo `vercel-labs/agent-skills`.

### Modified Capabilities

- `project-scaffolding`: ampliar as stacks aceitas pelo comando `new` e preservar os artefatos rckit/OpenSpec/OpenCode em projetos Astro.
- `component-catalog`: catalogar a integração de agent skills com dependências, lifecycle, custo de contexto e ausência de credenciais obrigatórias.

## Impact

Serão afetados `config/manifest.yaml`, `config/profiles.yaml`, `lib/scaffold.sh`, módulos em `modules/`, templates em `templates/project/`, testes e README. O runtime mínimo de Astro passa a depender de uma versão par suportada do Node.js igual ou superior a 22.12.0; a instalação de skills dependerá de Node.js/npm e de acesso ao GitHub/npm no momento da execução.
