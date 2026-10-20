## O que é este template?

**OpenMausBot** é um app de código aberto para gerenciar agentes de IA como
contatos de um chat. Cada bot roda com a CLI do **Claude Code** ou do
**Codex**, tem sua própria memória, rotinas agendadas e apps conectados, e você
conversa com ele pelo navegador ou pelo celular. Este template implanta o
servidor do OpenMausBot na ShardCloud como um app **Node.js**, sem banco de
dados anexado.

## O que o OpenMausBot faz?

- Roda bots que usam o Claude Code e o Codex com o **seu** login e a **sua**
  assinatura, sem proxy no meio
- Guarda conversas, memória e rotinas no próprio app, então os bots continuam
  rodando com o seu computador desligado
- Expõe uma interface web (instalável no celular) para conversar com os bots e
  aprovar ações

### Fluxo básico de uso

```
Deploy do template → Código de pareamento aparece nos logs
                                    ↓
              Abrir <url do app>/pair e digitar o código
                                    ↓
        Settings → Engines: entrar no Claude e/ou no Codex
                                    ↓
                          Criar bots e conversar
```

## Importante: exposição pública

Este template expõe a interface publicamente. O acesso é protegido por
**pareamento**: cada navegador precisa de um código de uso único (válido por 5
minutos) para entrar. Os bots rodam comandos dentro do container do app, então
trate uma sessão pareada como uma credencial de root, e não pareie
dispositivos que você não conhece.

Os logins do Claude e do Codex ficam salvos em `/app/.claude` e
`/app/.codex`. Quem tiver acesso aos arquivos do app, incluindo backups, tem
acesso a esses tokens.

## Estrutura do projeto

```
openmausbot/
├── package.json          ← Declara openmausbot, claude-code e codex
├── start.sh              ← Configura o ambiente e inicia o servidor
├── bind.cjs              ← Faz o servidor escutar na porta 80 pública
├── .shardcloud           ← Config de deploy da ShardCloud
└── docs/
    ├── _manifest.json
    ├── 01-intro.md       ← Esta página
    └── 02-config.md      ← Configuração
```

## Próximos passos

1. **[Configurar o app](02-config.md)**: variável de ambiente, pareamento e
   login no Claude e no Codex
