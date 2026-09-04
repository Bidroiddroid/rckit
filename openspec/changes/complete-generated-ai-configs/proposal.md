## Why

Projetos criados com `ai-dev new` estão nascendo sem a configuração completa de OpenSpec e OpenCode esperada para desenvolvimento com IA. O `openspec/config.yaml` do próprio rckit contém o conhecimento caro e as regras principais, mas o template usado em novos projetos ainda está mínimo, então o projeto gerado perde contexto, convenções, armadilhas e integração de agente.

## What Changes

- Completar `templates/openspec/config.yaml` com o mesmo modelo rico solicitado para o projeto, usando `{{PROJECT_NAME}}` como nome dinâmico do projeto gerado.
- Completar `templates/opencode/opencode.json` para projetos gerados com permissões conservadoras, MCPs opt-in e estrutura preparada para skills/agentes.
- Garantir que `ai-dev new <nome>` e `ai-dev new .` copiem os templates completos para o projeto final.
- Adicionar validação nos testes para impedir regressão para templates mínimos.
- Documentar que instalar ferramentas e criar arquivos do projeto são fluxos diferentes: instalação prepara a máquina; `--new` gera arquivos no projeto.

Não há **BREAKING CHANGES**.

## Capabilities

### New Capabilities

- `generated-openspec-template`: garante que projetos gerados recebam um `openspec/config.yaml` completo, com contexto real do projeto, arquitetura, convenções, regras e observações.
- `generated-opencode-template`: garante que projetos gerados recebam configuração OpenCode útil e segura, incluindo permissões conservadoras, MCPs opt-in e preparação para skills locais.
- `project-scaffolding-validation`: garante que o scaffold valide arquivos gerados de OpenSpec/OpenCode e não permita regressão para templates mínimos.

### Modified Capabilities

Nenhuma.

## Impact

- Afeta `templates/openspec/config.yaml`, `templates/opencode/opencode.json`, templates auxiliares de OpenCode se necessário, `lib/scaffold.sh`, testes em `tests/smoke.sh`/`tests/contracts.sh` e documentação no `README.md`.
- Não altera a API pública principal da CLI.
- Não grava secrets em arquivos gerados.
- Não instala MCPs automaticamente em projetos; apenas prepara configuração segura para uso quando selecionados.
