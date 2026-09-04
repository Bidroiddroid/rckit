## Context

O catálogo possui 32 componentes e seis perfis, mas alguns módulos ainda dependem do lifecycle genérico, cujo fallback de instalação, configuração, atualização e remoção apenas registra placeholders. Serviços Docker verificam somente a existência do Docker, e os testes atuais exercitam principalmente resolução, dry-run e geração de arquivos. A distribuição ocorre pela branch `main` do GitHub e deve funcionar em Ubuntu, Debian e WSL2 Ubuntu com um único comando.

## Goals / Non-Goals

**Goals:**

- Fazer o catálogo representar apenas capacidades funcionais e verificáveis.
- Manter instalação seletiva, idempotente, segura e compatível com dry-run.
- Validar o caminho completo GitHub -> instalador remoto -> CLI -> módulos/scaffold.
- Preservar configurações, secrets, projetos e volumes existentes.
- Disponibilizar `ai-dev` após a instalação e manter documentação executável.

**Non-Goals:**

- Suportar distribuições fora de Ubuntu, Debian e WSL2 Ubuntu nesta mudança.
- Iniciar todos os serviços Docker automaticamente em toda instalação.
- Armazenar credenciais ou automatizar consentimentos OAuth.
- Criar frontend, telemetria ou banco central para o bootstrap.

## Decisions

### Classificar componentes por resultado verificável

Cada componente declarará um tipo operacional: pacote/CLI do host, configuração MCP ou serviço/template de projeto. A verificação será específica ao resultado esperado e nunca aceitará apenas uma dependência genérica. Alternativa considerada: manter todos os itens como “instalação”; rejeitada porque gera falsos positivos para bancos e painéis Docker.

### Eliminar fallback de sucesso para operações não implementadas

O lifecycle genérico continuará compartilhando operações apt quando aplicável, mas operações sem comportamento real falharão com mensagem acionável. Um teste estático impedirá componentes publicados de herdarem placeholders. Alternativa considerada: manter avisos sem falha; rejeitada porque o runtime marca o componente como instalado após a verificação.

### Usar mecanismos oficiais e versões mínimas explícitas

Ferramentas sem pacote apt adequado usarão o método oficial documentado pelo fornecedor, com origem revisada, comando verificável e pré-requisitos no manifesto. Node para Playwright será 20+, e diferenças entre `opencode`/`opencode2` e schemas de configuração serão tratadas explicitamente. Alternativa considerada: instalar tudo por apt; rejeitada por versões defasadas ou pacotes indisponíveis.

### Provisionar serviços Docker por artefatos de projeto

PostgreSQL, Redis, MySQL, Traefik e Portainer serão materializados em Compose/templates selecionáveis e verificados pelo serviço/configuração correspondente. Dados e volumes não serão removidos por operações comuns. Não há mudança no banco central, pois ele não existe; o impacto é somente nos serviços opcionais gerados. Alternativa considerada: containers globais no bootstrap; rejeitada por conflitos de portas, nomes e credenciais entre projetos.

### Separar instalação da ferramenta e criação do projeto

O comando remoto atualizará o clone do rckit, disponibilizará `ai-dev` em `~/.local/bin` e delegará os argumentos. `--new <nome>` e `--new .` continuarão sendo operações explícitas; o nome `rckit` nunca será usado como nome do sistema gerado. Alternativa considerada: criar projeto automaticamente após selecionar componentes; rejeitada porque instalação de máquina e scaffold têm destinos e ciclos diferentes.

### Atualizar projetos por reconciliação conservadora

Arquivos ausentes serão criados; arquivos reconhecidamente antigos poderão ser copiados para backup antes de regenerar; arquivos personalizados serão preservados. A árvore OpenSpec/OpenCode será validada por conteúdo e estrutura. Alternativa considerada: sobrescrever sempre; rejeitada por risco de perda de trabalho.

### Criar uma barreira de release reproduzível

CI e validação local executarão sintaxe, contratos, smoke, auditoria de placeholders, scaffold novo/legado e instalação remota simulada. Um teste separado em ambiente limpo validará ferramentas reais sem alterar a máquina do desenvolvedor. Os exemplos do README serão extraídos ou testados para evitar divergência. A publicação só ocorrerá após essas verificações.

## Risks / Trade-offs

- [Instaladores oficiais mudam ou ficam indisponíveis] -> Fixar requisitos mínimos, centralizar URLs, testar periodicamente e falhar com diagnóstico.
- [Testes de instalação real são lentos] -> Separar testes rápidos obrigatórios de uma matriz limpa de integração.
- [Operações apt/npm/pip exigem privilégios ou PATH atualizado] -> Detectar pré-condições, mostrar plano e validar o binário no ambiente efetivo.
- [Atualização de projeto sobrescreve personalizações] -> Usar reconciliação conservadora, backups identificáveis e testes de conteúdo preservado.
- [Serviços Compose entram em conflito com projetos existentes] -> Gerar nomes/portas configuráveis e não iniciar nem remover dados implicitamente.
- [MCP configurado mas indisponível na rede ou sem credencial] -> Separar validação estrutural, runtime e autenticação; `doctor` reporta cada estado.
- [Mudança de classificação surpreende usuários] -> Documentar BREAKING CHANGE, atualizar perfis e fornecer migração nos comandos.

## Migration Plan

1. Auditar e classificar o catálogo atual, mantendo IDs quando o comportamento continuar equivalente.
2. Implementar operações reais e verificações específicas por grupo de componentes.
3. Migrar estado local de forma compatível; entradas antigas serão reconciliadas por `verify`.
4. Atualizar scaffold, README, exemplos e testes.
5. Executar validação rápida e matriz limpa; publicar na `main` somente após aprovação.
6. Validar o arquivo raw e executar o comando público após o push.

Rollback: reverter o commit publicado sem apagar `~/.local/share/rckit`, configurações de usuário, projetos ou volumes. Instalações já realizadas permanecem no host e serão diagnosticadas pela versão anterior.

## Open Questions

- Confirmar durante a implementação quais serviços devem ser incluídos em cada template de stack e quais permanecem seleção adicional.
- Confirmar a versão/schema oficial do OpenCode suportada no momento da implementação.
- Definir se a matriz limpa será GitHub Actions, containers locais privilegiados ou ambos, conforme suporte necessário a systemd/Docker.
