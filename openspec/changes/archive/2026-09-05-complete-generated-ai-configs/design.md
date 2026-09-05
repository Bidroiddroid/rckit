## Context

O rckit já possui `openspec/config.yaml` rico no próprio repositório, mas projetos gerados por `ai-dev new` usam `templates/openspec/config.yaml`, que ainda contém apenas `version` e `project`. O template OpenCode também está mínimo: cria um arquivo JSON válido, mas não expressa de forma suficiente o contrato esperado para permissões conservadoras, MCPs opt-in, skills locais e funcionamento com agentes.

O usuário espera que, ao criar um projeto novo e abrir `code .`, o projeto já contenha arquivos completos de orientação para IA, OpenSpec e OpenCode. Instalar ferramentas na máquina e gerar arquivos do projeto são fluxos separados, mas ambos precisam produzir uma experiência coerente.

## Goals / Non-Goals

**Goals:**

- Fazer `templates/openspec/config.yaml` carregar o modelo completo em português, usando `{{PROJECT_NAME}}` para o projeto gerado.
- Fazer `templates/opencode/opencode.json` ser uma configuração completa e conservadora para uso inicial, sem tokens e com MCPs vazios por padrão.
- Manter MCPs opt-in: instalar/configurar MCP selecionado continua sendo responsabilidade do instalador, não do scaffold base.
- Validar por testes que projetos novos recebem OpenSpec completo, OpenCode completo e nome correto.
- Documentar como atualizar um projeto já criado quando o scaffold anterior gerou arquivos mínimos.

**Non-Goals:**

- Não criar uma aplicação web ou interface gráfica dentro do projeto gerado.
- Não instalar automaticamente todos os MCPs no projeto gerado.
- Não gravar `GITHUB_PERSONAL_ACCESS_TOKEN`, `DATABASE_URL`, `FIRECRAWL_API_KEY` ou qualquer segredo.
- Não sobrescrever arquivos existentes sem confirmação.

## Decisions

### Usar o template do projeto como fonte principal para novos scaffolds

`templates/openspec/config.yaml` deve ser completo, não um ponteiro para `openspec/config.yaml`. Isso garante que máquinas novas e projetos gerados por qualquer commit do rckit tenham um artefato autocontido.

Alternativa considerada: copiar o `openspec/config.yaml` do rckit em tempo de execução. Isso mistura contexto da ferramenta de bootstrap com contexto do projeto gerado e aumenta risco de levar detalhes internos do rckit que não fazem sentido para o novo sistema.

### Manter placeholders seguros e mínimos

O template OpenSpec deve usar `{{PROJECT_NAME}}` para nome do projeto e manter seções preenchíveis para domínio, módulos e decisões reais do novo sistema. O conteúdo padrão deve ser útil, mas não fingir detalhes de negócio que o usuário ainda não informou.

Alternativa considerada: deixar campos genéricos vazios. Isso repete o problema atual, em que o agente abre o projeto sem contexto suficiente.

### OpenCode deve nascer conservador

O template OpenCode deve pedir permissão para escrita e shell, permitir leitura, declarar MCPs vazios e preparar diretórios/skills locais. MCPs selecionados pelo usuário serão mesclados posteriormente pelo instalador.

Alternativa considerada: já incluir todos os MCPs no `.opencode/opencode.json` gerado. Isso aumenta contexto, risco de credenciais ausentes e exposição indevida de navegador/banco/crawlers.

### Testes devem validar conteúdo, não apenas existência

Os testes devem verificar marcadores reais como `schema: spec-driven`, `Conhecimento caro`, regras de proposal/design/specs/tasks, seção MCP em OpenCode e ausência de placeholders não resolvidos.

Alternativa considerada: testar só que os arquivos existem. Isso não detecta regressão para arquivos mínimos.

## Risks / Trade-offs

- Template OpenSpec muito longo pode gerar ruído no projeto novo -> Mitigação: manter estrutura rica, mas com textos orientadores e placeholders seguros para o domínio específico.
- OpenCode muda schema entre versões -> Mitigação: manter JSON válido, permissões conservadoras e testes de parse; documentar que mudanças de schema exigem atualização dos templates.
- Projetos já criados continuam com arquivos mínimos -> Mitigação: documentar comando `ai-dev new . --stack <stack>` para escrever arquivos faltantes e avisar que arquivos existentes não são sobrescritos sem confirmação.
- MCPs podem parecer “não configurados” no projeto base -> Mitigação: documentar que MCPs são opt-in e que seleção/credenciais acontecem no fluxo de instalação.
