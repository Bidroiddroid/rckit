## 1. Auditoria e contrato do catálogo

- [x] 1.1 Inventariar os 32 componentes, classificar cada um como host CLI, MCP ou serviço/template de projeto e registrar método oficial, versão mínima e verificação esperada
- [x] 1.2 Atualizar `config/manifest.yaml` e `config/profiles.yaml` para refletir apenas dependências e componentes funcionalmente suportados
- [x] 1.3 Alterar o lifecycle genérico para falhar de forma acionável quando uma operação necessária não possuir implementação real
- [x] 1.4 Adicionar validação estática que rejeite módulo publicado com instalação, atualização, remoção ou verificação placeholder
- [x] 1.5 Garantir que estado antigo seja reconciliado por verificação real sem confiar em `state/installed.yaml`

## 2. Ferramentas base e linguagens

- [x] 2.1 Validar e completar módulos apt de system, Git, GitHub CLI, Make, jq, yq, ripgrep e fd com verificações específicas
- [x] 2.2 Implementar instalação oficial, configuração de PATH, update, verify e doctor do mise
- [x] 2.3 Corrigir Node.js para garantir versão compatível com Playwright MCP e instalação verificável de npm, pnpm e TypeScript
- [x] 2.4 Corrigir Python para ambientes modernos com proteção contra pip gerenciado externamente e verificação de uv e Ruff
- [x] 2.5 Completar PHP, Composer e Laravel com instalação oficial, versões mínimas, update e verify idempotentes

## 3. Docker e serviços de projeto

- [x] 3.1 Implementar Docker e Compose com instalação suportada, daemon/permissões diagnosticáveis e dry-run fiel
- [x] 3.2 Definir templates Compose selecionáveis para PostgreSQL, Redis, MySQL, Traefik e Portainer com volumes e portas seguras
- [x] 3.3 Substituir verificações baseadas apenas em `command -v docker` por validação específica do serviço ou artefato configurado
- [x] 3.4 Implementar update/remove conservadores para serviços sem apagar volumes ou projetos implicitamente
- [x] 3.5 Testar geração e parsing das configurações Compose para cada stack suportada

## 4. OpenCode, OpenSpec e segurança

- [x] 4.1 Confirmar fontes e schemas oficiais atuais de OpenCode e OpenSpec e registrar as decisões em `docs/official-sources.md`
- [x] 4.2 Implementar instalação, update, verify e doctor reais de OpenCode, tratando os binários suportados e configuração existente
- [x] 4.3 Implementar instalação, update, verify e doctor reais da CLI OpenSpec
- [x] 4.4 Implementar Gitleaks, Trivy e Semgrep pelos métodos suportados, com versões verificáveis e PATH correto
- [x] 4.5 Remover prompts genéricos de credencial e orientar autenticação específica para GitHub CLI/OpenCode sem armazenar secrets

## 5. MCPs funcionais

- [x] 5.1 Validar todos os fragmentos MCP contra o schema OpenCode suportado e testar merge idempotente preservando configuração do usuário
- [x] 5.2 Validar Context7, Playwright e Chrome DevTools sem credenciais, incluindo Node 20+, npx, navegador e diagnóstico de runtime
- [x] 5.3 Validar GitHub, PostgreSQL, Sentry e Firecrawl com separação clara entre configuração, credencial/OAuth e conectividade
- [x] 5.4 Garantir que tokens sejam lidos somente do ambiente ou fluxo oficial e nunca apareçam em configuração versionada, estado ou logs
- [x] 5.5 Adicionar testes de doctor para estados configurado, credencial ausente, pré-requisito ausente e pronto

## 6. Comando remoto e CLI persistente

- [x] 6.1 Tornar `remote-install.sh` idempotente para clone, atualização fast-forward e delegação integral de argumentos
- [x] 6.2 Validar checklist por teclado e mouse via TTY e erro acionável em execução não interativa sem seleção
- [x] 6.3 Instalar um launcher `ai-dev` em `~/.local/bin` sem depender do diretório atual e diagnosticar PATH ausente
- [x] 6.4 Cobrir componentes explícitos, perfis, `--dry-run`, `--yes`, `--new <nome>` e `--new .` pelo mesmo comando público
- [x] 6.5 Garantir que dry-run não escreva configuração, estado, logs persistentes, projetos ou pacotes do host

## 7. Scaffold completo e migração

- [x] 7.1 Validar e completar a árvore base para Node, Python e Laravel com nome de projeto correto
- [x] 7.2 Validar JSON do OpenCode, skills copiadas e estrutura OpenSpec com config, README, changes e specs
- [x] 7.3 Implementar detecção robusta de templates antigos com backup antes de regeneração
- [x] 7.4 Preservar arquivos personalizados e criar somente itens ausentes em projeto existente
- [x] 7.5 Adicionar teste de conteúdo para regras OpenSpec, conhecimento caro, ausência de secrets e substituição de `{{PROJECT_NAME}}`

## 8. Testes e integração contínua

- [x] 8.1 Ampliar `tests/contracts.sh` para catálogo, módulos, schemas, placeholders, secrets e documentação
- [x] 8.2 Ampliar `tests/smoke.sh` para lifecycle, idempotência, seleção, PATH e scaffolds novo/legado
- [x] 8.3 Criar teste de integração do instalador remoto usando clone temporário e ambiente isolado
- [x] 8.4 Criar matriz limpa para Ubuntu/Debian que execute perfis representativos e verificações reais sem alterar a máquina do desenvolvedor
- [x] 8.5 Adicionar workflow de CI com `bash -n`, contracts, smoke e testes limpos adequados ao evento
- [x] 8.6 Executar testes de segurança e confirmar que nenhuma saída ou fixture contém credenciais reais

## 9. Documentação e comandos

- [x] 9.1 Reescrever Quick Start em português com comando único para seleção, perfil, componente e projeto novo
- [x] 9.2 Corrigir orientação de atualização de projeto para refletir backup automático e preservação de arquivos
- [x] 9.3 Documentar claramente o que cada componente instala, quais são serviços de projeto e quais credenciais/OAuth são necessários
- [x] 9.4 Documentar PATH, suporte a Ubuntu/Debian/WSL2, limitações, recuperação de erros e comportamento de dry-run
- [x] 9.5 Validar automaticamente todos os comandos principais mostrados no README

## 10. Deploy e validação final

- [x] 10.1 Executar a suíte completa e revisar todos os módulos para confirmar ausência de falso sucesso e placeholders funcionais
- [x] 10.2 Revisar o diff geral, arquivos gerados, permissões executáveis e histórico remoto antes da publicação
- [x] 10.3 Integrar as mudanças ao clone Git gravável e publicar commit na branch `main` do GitHub sem sobrescrever histórico
- [x] 10.4 Validar o `remote-install.sh` raw publicado e executar os comandos públicos em diretórios temporários
- [x] 10.5 Validar uma aplicação Node, Python e Laravel gerada, incluindo OpenCode, OpenSpec e MCPs sem credenciais
- [x] 10.6 Limpar caches e artefatos temporários usados nos testes sem remover configurações, projetos ou volumes do usuário
- [x] 10.7 Realizar revisão geral do projeto e registrar limitações residuais ou dependências externas ainda não verificáveis

## 11. Paridade oficial do OpenSpec

- [x] 11.1 Gerar uma referência oficial OpenSpec core com entrega de skills e comandos para OpenCode e registrar a árvore esperada
- [x] 11.2 Adicionar os quatro comandos oficiais `opsx-*`, as quatro skills core específicas para OpenCode e `openspec/changes/archive/` aos templates
- [x] 11.3 Atualizar o scaffold para instalar a árvore oficial sem remover skills extras nem sobrescrever o `config.yaml` enriquecido
- [x] 11.4 Adicionar teste de paridade estrutural e de conteúdo com a saída oficial da CLI OpenSpec suportada
- [x] 11.5 Validar criação nova e reparo de projeto antigo incompleto, incluindo execução pelo instalador remoto
- [x] 11.6 Atualizar README e documentação para listar exatamente os arquivos OpenSpec/OpenCode gerados
- [ ] 11.7 Executar auditoria completa, publicar no GitHub e validar o instalador raw atualizado
