## ADDED Requirements

### Requirement: Instalação por comando único
O comando público via GitHub MUST baixar o instalador, instalar Git quando necessário, clonar ou atualizar o rckit e delegar todos os argumentos em uma única execução visível.

#### Scenario: Máquina suportada sem clone prévio
- **WHEN** o usuário executa o comando público com um componente ou perfil
- **THEN** o repositório é obtido no diretório configurado e o plano correspondente é executado

### Requirement: Seleção interativa por caixas
Quando executado sem seleção em terminal interativo, o instalador MUST abrir uma checklist navegável por teclado e, quando suportado pelo terminal, por mouse; sem TTY MUST falhar com orientação acionável.

#### Scenario: Pipeline preserva acesso ao terminal
- **WHEN** `wget` envia o script por pipe e `/dev/tty` está disponível
- **THEN** a checklist recebe entrada do terminal e os componentes marcados são delegados

### Requirement: Comando persistente disponível
Após a instalação, `ai-dev` MUST estar executável por um caminho padrão do usuário ou a saída MUST fornecer o comando exato para habilitar esse caminho na sessão atual.

#### Scenario: Diretório local não está no PATH
- **WHEN** o launcher é instalado em `~/.local/bin` e esse diretório não está no `PATH`
- **THEN** a instalação conclui com instrução acionável e `doctor` detecta a pendência

### Requirement: Dry-run sem efeitos colaterais
`--dry-run` MUST mostrar o plano completo sem instalar pacotes, alterar configurações, criar estado de instalação ou exigir verificação posterior de mudanças simuladas.

#### Scenario: Perfil executado em dry-run
- **WHEN** o usuário executa o comando remoto com `--profile developer --dry-run`
- **THEN** todos os componentes resolvidos são exibidos e o host permanece inalterado
