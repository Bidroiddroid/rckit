# Componentes

Os componentes são registrados em `config/manifest.yaml`, resolvidos por dependência e implementados em `modules/`. Consulte `docs/component-inventory.md` para o resultado verificável de cada item.

Para adicionar um componente:

1. Defina se ele instala uma CLI do host, configura um MCP ou gera um serviço Compose.
2. Crie `modules/<component>/module.sh` com instalação, configuração, verificação, atualização, remoção e diagnóstico reais.
3. Registre categoria, dependências, plataformas, credenciais e custo de contexto no manifesto.
4. Inclua o componente em perfil somente quando ele for um padrão útil.
5. Adicione testes de resolução, dry-run, idempotência, falha e verificação específica.

Operações sem implementação não podem retornar sucesso. A presença de uma dependência, como Docker, não comprova que PostgreSQL ou outro serviço foi configurado.
