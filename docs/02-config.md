## Pré-requisitos

- Uma **conta na ShardCloud**
- Uma assinatura do **Claude** (Pro, Max, Team ou Enterprise) e/ou do
  **ChatGPT**, ou uma chave de API de um dos dois

## 1. Deploy do template

Nenhum banco de dados é anexado. O OpenMausBot guarda o próprio estado em
`/app`. Antes de iniciar o app pela primeira vez, confira:

| Variável        | Descrição                                                                                                                         |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `PUBLIC_ORIGIN` | Já vem como `{DOMAIN}`, preenchido automaticamente com a URL pública do app. Usada nos links de pareamento e na verificação de origem |

O app usa **Node.js 24** (o OpenMausBot exige Node 24 ou superior) e **2 GB**
de memória.

## 2. Primeira inicialização

Na primeira vez, o app instala as dependências (`openmausbot`, `claude` e
`codex`), o que pode levar alguns minutos. Nas reinicializações seguintes a
instalação é pulada. Acompanhe os logs até aparecer o **código de pareamento**.

## 3. Parear o navegador

1. Copie o código de pareamento dos logs (12 caracteres, uso único, válido por
   5 minutos)
2. Abra `https://<url do app>/pair` e digite o código

A sessão dura 30 dias e é renovada a cada uso. Para parear outro dispositivo,
reinicie o app para gerar um novo código (cada início imprime um) ou use
**Settings → Phone** dentro do OpenMausBot.

## 4. Entrar no Claude e no Codex

Abra as configurações (**Settings**), vá no grupo **AI** e escolha
**Engines**. Há um cartão para o **Claude** e outro para o **ChatGPT**
(Codex). Use o botão de login do cartão (o texto exato depende do idioma da
interface):

- **Claude**: abre a página de login da Anthropic. Copie o código que ela
  mostrar e cole de volta no OpenMausBot (o botão de concluir só habilita com
  pelo menos 8 caracteres).
- **ChatGPT (Codex)**: o OpenMausBot mostra um código de uso único para você
  digitar na página da OpenAI. O login por código de dispositivo precisa estar
  ativado nas configurações de segurança do ChatGPT.
- **Chave de API**: em **Settings → Connections → Model providers** você pode
  usar uma chave de API da Anthropic no lugar do login pessoal.

Os logins ficam em `/app/.claude` e `/app/.codex` e continuam valendo depois de
reiniciar o app.

**Não apareceu o botão de login?** Se o cartão mostra a configuração do motor
em vez do login, o OpenMausBot não encontrou a CLI. Em **Engines**, abra as
opções avançadas do motor, escolha **Set CLI** e informe o caminho
`/app/node_modules/.bin/claude` (ou `/app/node_modules/.bin/codex`). Só um
navegador pareado com acesso total vê as configurações.

## Limitações

- Só a porta 80 é exposta. Webhooks que chegam de fora (porta separada do
  OpenMausBot) não funcionam neste template.
- O Chrome não vem instalado, então a ferramenta de navegador dos bots não está
  disponível.
- Não ative o reinício gracioso (graceful restart) neste app. Ele sobe um
  segundo container sobre o mesmo `/app` por alguns segundos, e o OpenMausBot
  não pode ter duas instâncias na mesma pasta de dados. O `start.sh` apaga o
  arquivo de trava (`openmausbot-server.lease`) a cada início, porque o
  reinício comum encerra o container sem que o servidor consiga liberá-lo.
- O app tem limite de CPU e memória do plano. Muitos bots rodando ao mesmo
  tempo podem ficar lentos.

## Como a porta 80 funciona

O servidor do OpenMausBot escuta fixo em `127.0.0.1`, e a ShardCloud só roteia
a porta 80 em `0.0.0.0` para o app. O `start.sh` carrega o `bind.cjs` com
`NODE_OPTIONS=--require` para trocar esse endereço, sem proxy no meio. O acesso
continua protegido pelo pareamento do próprio servidor.

## Atualizar versões

As versões do `openmausbot`, `@anthropic-ai/claude-code` e `@openai/codex` estão
fixadas no `package.json`. Altere os números e reinicie o app para atualizar.

## Referências

- [Repositório do OpenMausBot](https://github.com/milind-soni/OpenMausBot)
- [Guia de self-hosting](https://github.com/milind-soni/OpenMausBot/blob/main/docs/self-hosting.md)
