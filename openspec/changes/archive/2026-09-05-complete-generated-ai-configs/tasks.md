## 1. OpenSpec Template

- [x] 1.1 Substituir `templates/openspec/config.yaml` mínimo por template completo baseado no modelo solicitado pelo usuário.
- [x] 1.2 Usar `{{PROJECT_NAME}}` de forma segura no template para nome, contexto e exemplos do projeto gerado.
- [x] 1.3 Preservar no template as convenções, módulos, regras de proposal/design/specs/tasks e armadilhas aprendidas no rckit.

## 2. OpenCode Template

- [x] 2.1 Expandir `templates/opencode/opencode.json` com configuração inicial segura e completa para projetos gerados.
- [x] 2.2 Manter permissões conservadoras para edição e shell.
- [x] 2.3 Manter MCPs opt-in e sem credenciais reais em arquivos versionados.
- [x] 2.4 Garantir compatibilidade com os fragmentos MCP já existentes em `templates/opencode/mcp/*.json`.

## 3. Scaffold

- [x] 3.1 Confirmar que `ai-dev new <nome>` copia os templates completos para novos projetos.
- [x] 3.2 Confirmar que `ai-dev new .` copia os templates completos para a pasta atual usando o nome da pasta.
- [x] 3.3 Preservar arquivos existentes e informar quando algum arquivo for pulado.

## 4. Tests

- [x] 4.1 Atualizar `tests/smoke.sh` para verificar conteúdo real do OpenSpec gerado, não só existência do arquivo.
- [x] 4.2 Atualizar `tests/contracts.sh` para validar JSON OpenCode completo e ausência de secrets reais nos templates.
- [x] 4.3 Adicionar verificação para impedir regressão de `templates/openspec/config.yaml` para configuração mínima.
- [x] 4.4 Rodar `bash -n`, `tests/smoke.sh` e `tests/contracts.sh`.

## 5. Documentation And Deployment

- [x] 5.1 Documentar como criar arquivos na pasta atual e como reparar projeto criado com templates antigos.
- [x] 5.2 Revisar os arquivos gerados em diretório temporário com `ai-dev new .`.
- [x] 5.3 Publicar a correção no GitHub.
- [x] 5.4 Validar o fluxo remoto com `remote-install.sh -- --new . --stack node` em diretório temporário.
- [x] 5.5 Limpar arquivos temporários/cache de teste quando aplicável.
- [x] 5.6 Fazer revisão geral para secrets, placeholders não resolvidos e configurações inseguras.

## 6. Complete Generated Directory Trees

- [x] 6.1 Criar templates versionáveis para `openspec/changes/` e `openspec/specs/`.
- [x] 6.2 Criar documentação base `openspec/README.md` para projetos gerados.
- [x] 6.3 Copiar skills do rckit para `.opencode/skills/` em projetos gerados.
- [x] 6.4 Detectar `openspec/config.yaml` e `.opencode/opencode.json` antigos/incompletos, fazer backup e recriar versões completas.
- [x] 6.5 Atualizar testes para validar diretórios, arquivos, skills e refresh seguro de configs antigas.
