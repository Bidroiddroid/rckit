## 1. Contratos oficiais e catálogo

- [x] 1.1 Confirmar e registrar versões e flags não interativas do Astro `create-astro` e do CLI skills usadas pela implementação
- [x] 1.2 Adicionar Astro e `agent-skills` ao catálogo com categorias, dependências, plataformas, credenciais e custo de contexto corretos
- [x] 1.3 Ajustar o módulo Node.js para instalar e verificar versão par suportada igual ou superior a 22.12.0 sem regredir dependentes existentes
- [x] 1.4 Atualizar perfis somente onde a inclusão for explicitamente desejada, mantendo `agent-skills` fora das seleções padrão

## 2. Stack Astro

- [x] 2.1 Ampliar parsing, ajuda e validação de `ai-dev new` para aceitar `--stack astro`
- [x] 2.2 Implementar criação não interativa pelo gerador oficial com nome, destino e tratamento de falhas parciais
- [x] 2.3 Aplicar AGENTS.md, OpenCode, OpenSpec, docs e testes depois do gerador sem substituir arquivos controlados pelo Astro
- [x] 2.4 Suportar com segurança projeto nomeado e destino `.` existente, preservando confirmação e arquivos personalizados
- [x] 2.5 Implementar dry-run Astro sem rede ou escrita e verificação estrutural/build do projeto criado

## 3. Agent skills

- [x] 3.1 Criar módulo `agent-skills` com instalação oficial de `vercel-labs/agent-skills` no projeto alvo sem privilégios
- [x] 3.2 Implementar detecção e verificação por arquivos `SKILL.md` reais, sem confiar exclusivamente no estado local
- [x] 3.3 Implementar update e doctor com diagnósticos para Node, npm/npx, Git, rede, projeto alvo e coleção incompleta
- [x] 3.4 Implementar remoção conservadora que preserve skills próprias e recuse apagar arquivos de propriedade ambígua
- [x] 3.5 Garantir dry-run sem execução de `npx`, download, escrita ou registro de falso sucesso
- [x] 3.6 Preservar configurações e skills existentes, com backup e confirmação em qualquer migração necessária

## 4. Testes

- [x] 4.1 Adicionar contratos para catálogo, dependências, versão Node, comandos oficiais, ausência de secrets e inexistência de placeholders
- [x] 4.2 Adicionar smoke tests do plano, dry-run, help, seleção, lifecycle e idempotência de Astro e `agent-skills`
- [x] 4.3 Testar scaffold Astro novo e reparo em destino existente com geradores simulados determinísticos
- [x] 4.4 Testar preservação de arquivos Astro e skills personalizadas, incluindo remoção com propriedade ambígua
- [x] 4.5 Executar integração controlada com gerador Astro e coleção Vercel oficiais quando houver rede disponível
- [x] 4.6 Executar audit, contracts, smoke, integration, validação OpenSpec e matriz limpa Ubuntu/Debian aplicável

## 5. Documentação

- [x] 5.1 Atualizar README com os comandos únicos para instalar o componente e criar projeto Astro, incluindo exemplos de dry-run
- [x] 5.2 Documentar requisitos de Node, origem externa, custo de contexto, comportamento opt-in, atualização e recuperação de falhas
- [x] 5.3 Atualizar fontes oficiais e árvore esperada dos projetos gerados sem afirmar que skills.sh é uma skill individual

## 6. Deploy e validação final

- [x] 6.1 Revisar diff, permissões executáveis, segurança de supply chain, compatibilidade das stacks antigas e ausência de dados locais
- [x] 6.2 Publicar a mudança na branch `main` sem sobrescrever o histórico remoto
- [ ] 6.3 Validar o instalador raw publicado, a seleção de `agent-skills` e a criação de uma aplicação Astro funcional
- [ ] 6.4 Confirmar GitHub Actions e validar a aplicação Astro gerada com instalação e build bem-sucedidos
- [ ] 6.5 Limpar caches e artefatos temporários dos testes sem remover projetos ou configurações do usuário
- [ ] 6.6 Realizar revisão geral e registrar limitações residuais de serviços externos e conteúdo de terceiros
