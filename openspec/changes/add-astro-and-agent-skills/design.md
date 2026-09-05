## Context

O scaffold atual aceita `node`, `python` e `laravel`, gera templates próprios e depois adiciona OpenCode/OpenSpec. Astro possui um gerador oficial (`npm create astro@latest`) e, em setembro de 2026, requer Node.js 22.12.0 ou superior em uma versão par suportada. O skills.sh é um diretório e ecossistema de distribuição; a coleção solicitada é instalada oficialmente com `npx skills add vercel-labs/agent-skills`.

A mudança cruza catálogo, lifecycle, criação de projetos, dependências externas, segurança de conteúdo executado por agentes e testes. Não há impacto em banco de dados, migrações, APIs HTTP ou serviços Docker. A API CLI ganha uma stack e um componente, mantendo os comandos existentes.

## Goals / Non-Goals

**Goals:**

- Criar projetos Astro reais pelo gerador oficial e complementar o resultado com os arquivos rckit.
- Oferecer `agent-skills` como instalação explícita da coleção `vercel-labs/agent-skills` em um projeto.
- Garantir dry-run sem rede ou escrita, lifecycle verificável, Node compatível e preservação de arquivos existentes.
- Cobrir projeto novo, destino `.` existente, repetição, falhas externas e documentação do comando único.

**Non-Goals:**

- Manter um fork do Astro, copiar o framework para templates locais ou instalar Astro globalmente.
- Espelhar todo o catálogo skills.sh, instalar automaticamente qualquer repositório ou habilitar skills sem seleção.
- Garantir o comportamento interno de código remoto de terceiros além de validar origem, estrutura instalada e resultado do comando oficial.
- Adicionar banco de dados, API HTTP, deploy Vercel ou integração frontend específica ao projeto gerado.

## Decisions

### Usar o gerador oficial do Astro

O fluxo `ai-dev new <nome> --stack astro` executará o `create-astro` oficial de forma não interativa, com nome/destino explícitos, e só depois aplicará os artefatos comuns do rckit. Isso evita manter uma cópia desatualizada do framework. A alternativa de criar somente um `package.json` local foi rejeitada porque perderia decisões, estrutura e compatibilidade do gerador oficial.

Para destino existente, especialmente `.`, o fluxo deve preservar a confirmação atual e passar opções compatíveis com diretório não vazio; se o gerador não puder operar com segurança, deve falhar antes de alterações parciais. O Node gerenciado pelo módulo `node` será elevado para satisfazer o mínimo oficial de Astro, sem aceitar versão ímpar não suportada.

### Tratar skills.sh como canal e a coleção como componente

O manifesto receberá `agent-skills`, dependente de `node` e `git`, sem credenciais obrigatórias e com custo de contexto visível. Sua configuração usará o CLI oficial para adicionar `vercel-labs/agent-skills` ao projeto atual. `skills.sh` não será representado como uma skill falsa nem como daemon global.

A alternativa de copiar o repositório da Vercel para os templates foi rejeitada porque congelaria conteúdo de terceiros, aumentaria o repositório e perderia o mecanismo oficial de descoberta/atualização. A alternativa de instalar todas as skills silenciosamente foi rejeitada por custo de contexto e risco de supply chain.

### Separar presença do CLI, instalação no projeto e verificação

O lifecycle deve verificar pré-requisitos reais, localizar a árvore de skills produzida para os agentes suportados e confirmar `SKILL.md` válidos associados à coleção. O estado local continua sendo apenas cache. Update deve reutilizar o mecanismo oficial; remove deve apagar somente arquivos comprovadamente gerenciados pelo componente, preservando skills próprias, ou recusar remoção quando a propriedade não puder ser demonstrada.

Dry-run exibirá o comando, origem e destino, mas não executará `npx`, rede ou escrita. Falhas de npm, GitHub ou incompatibilidade de agente devem retornar erro acionável.

### Manter compatibilidade e aplicação conservadora

Projetos Astro receberão AGENTS.md, OpenCode, OpenSpec, docs, testes e exemplos do rckit pelo mesmo mecanismo conservador das demais stacks. Arquivos do Astro têm precedência; o scaffold não deve substituir `package.json`, `astro.config.*`, `src/` ou configuração existente. Skills da Vercel também não podem substituir skills locais sem confirmação e backup.

## Risks / Trade-offs

- [Mudanças no gerador Astro ou no CLI skills] -> Fixar contratos testados, validar versões mínimas e manter testes de contrato que detectem alterações de flags/saída.
- [Execução de pacotes remotos por `npx`] -> Exigir seleção e confirmação, mostrar origem no plano, não usar privilégios e documentar que o conteúdo é de terceiros.
- [Node instalado mas abaixo de 22.12.0 ou em versão ímpar] -> Verificar semanticamente a versão antes do scaffold e orientar update pelo módulo Node.
- [Instalação parcial após falha de rede] -> Trabalhar em destino controlado, detectar resultado incompleto e emitir recuperação acionável sem declarar sucesso.
- [Sobrescrita de projeto ou skills existentes] -> Preservar o comportamento de confirmação, escrever apenas ausentes e criar backup quando uma migração explícita for necessária.
- [Custo de contexto das skills] -> Manter `agent-skills` fora dos perfis padrão e informar custo no plano.
- [Ambiguidade de diretório alvo] -> Resolver o alvo a partir do projeto solicitado ou diretório atual e recusar execução quando não houver raiz de projeto identificável.

## Migration Plan

1. Adicionar specs, catálogo e módulo sem alterar perfis padrão.
2. Ajustar Node e scaffold Astro, mantendo stacks antigas intactas.
3. Adicionar testes isolados com executáveis simulados e um teste oficial temporário quando houver rede controlada.
4. Atualizar documentação e publicar; validar CI e instalação remota.
5. Em rollback, remover as novas entradas/comandos; projetos Astro e skills já criados permanecem dados do usuário e não serão apagados automaticamente.

## Open Questions

Nenhuma questão bloqueante. Durante a implementação, as flags não interativas exatas do `create-astro` e do CLI `skills` serão confirmadas contra as versões oficiais usadas nos testes, sem assumir opções não documentadas.
