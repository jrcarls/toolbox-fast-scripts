# setup_django.sh

Script de inicialização de projetos Django com uma stack moderna e pré-configurada.

## Stack incluída

| Pacote | Função |
|---|---|
| [uv](https://docs.astral.sh/uv/) | Gerenciador de pacotes e ambiente virtual |
| [Django](https://www.djangoproject.com/) | Framework web |
| [django-environ](https://django-environ.readthedocs.io/) | Gerenciamento de variáveis de ambiente |
| [django-cotton](https://django-cotton.com/) | Componentes reutilizáveis de template |
| [django-htmx](https://django-htmx.readthedocs.io/) | Integração com HTMX |
| [django-allauth](https://docs.allauth.org/) | Autenticação e gerenciamento de contas |
| [django-debug-toolbar](https://django-debug-toolbar.readthedocs.io/) | Painel de debug em desenvolvimento |
| [django-browser-reload](https://github.com/adamchainz/django-browser-reload) | Live reload no desenvolvimento |
| [django-tabler-icons](https://github.com/christianwgd/django-tabler-icons) | Biblioteca de ícones |
| [WhiteNoise](https://whitenoise.readthedocs.io/) | Servidor de arquivos estáticos |
| [Pillow](https://pillow.readthedocs.io/) | Processamento de imagens |
| [HTMX](https://htmx.org/) | Interatividade sem JS complexo (baixado localmente) |
| [Alpine.js](https://alpinejs.dev/) | Reatividade leve no frontend (baixado localmente) |
| [Flowbite](https://flowbite.com/docs/getting-started/django/) + [Tailwind CSS](https://tailwindcss.com/) | Componentes interativos e utilitários CSS |

## O que o script faz

1. Cria o projeto com `uv init` e instala todas as dependências
2. Inicializa a estrutura Django com `django-admin startproject config .`
3. Cria a estrutura de diretórios:
   ```
   static/
   ├── css/     # Entrada e saída compilada do Tailwind/Flowbite
   └── js/      # HTMX, Alpine.js e Flowbite
   templates/
   ├── base.html
   └── cotton/  # Componentes django-cotton
   ```
4. Baixa HTMX e Alpine.js localmente (sem dependência de CDN em produção)
5. Instala Flowbite, Tailwind CSS e Tailwind CLI via npm
6. Gera o CSS inicial e copia o JavaScript do Flowbite para `static/js/`
7. Gera `templates/base.html` com HTMX, Alpine.js, Tailwind e Flowbite já conectados
8. Gera `.env` e `.env.example` com configurações iniciais
9. Atualiza `.gitignore` com arquivos gerados e sensíveis
10. Gera `config/settings.py` completamente configurado com todos os apps e middlewares
11. Executa `migrate` inicial

## Pré-requisitos

- [`uv`](https://docs.astral.sh/uv/getting-started/installation/) instalado
- [Node.js](https://nodejs.org/) e npm instalados
- `curl` disponível no sistema

Para instalar o `uv` no Linux ou macOS:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
uv --version
```

Confirme também que Node.js, npm e curl estão disponíveis:

```bash
node --version
npm --version
curl --version
```

## Como usar

### Instalar o comando globalmente

Execute uma vez, a partir da raiz deste repositório:

```bash
bash django/install.sh
```

O instalador cria `~/.local/bin/setup-django`. Caso o comando ainda não seja
encontrado, adicione esse diretório ao `PATH` e recarregue o terminal:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Depois, entre no diretório onde deseja criar o projeto e use:

```bash
cd ~/Projects
setup-django meu_projeto
```

O projeto será criado em `~/Projects/meu_projeto`.

### Executar diretamente, sem instalar o comando

A partir da raiz deste repositório, passe o nome do projeto:

```bash
bash django/setup_django.sh meu_projeto
```

Ou use o modo interativo:

```bash
bash django/setup_django.sh
# Nome do projeto: meu_projeto
```

Nos dois modos, a pasta do projeto é criada dentro do diretório atual. Para
criar o projeto fora da toolbox, chame o script pelo caminho absoluto:

```bash
cd ~/Projects
bash /caminho/para/toolbox-fast-scripts/django/setup_django.sh meu_projeto
```

### Após a execução

```bash
cd meu_projeto
uv run python manage.py createsuperuser
uv run python manage.py runserver
```

A aplicação ficará disponível em <http://127.0.0.1:8000/> e a administração
do Django em <http://127.0.0.1:8000/admin/>.

## Estrutura gerada

```
meu_projeto/
├── config/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── static/
│   ├── css/
│   │   ├── input.css        # Tailwind + tema/plugin do Flowbite
│   │   └── output.css       # CSS compilado (no .gitignore)
│   └── js/
│       ├── flowbite.min.js
│       ├── htmx.min.js
│       └── alpine.min.js
├── templates/
│   ├── base.html
│   └── cotton/              # Componentes django-cotton
├── .env                     # (no .gitignore)
├── .env.example
├── .gitignore
├── manage.py
├── package.json
├── package-lock.json
└── pyproject.toml
```

## Variáveis de ambiente (.env)

| Variável | Padrão | Descrição |
|---|---|---|
| `DEBUG` | `True` | Modo debug |
| `SECRET_KEY` | insecure key | Chave secreta do Django — troque em produção |
| `ALLOWED_HOSTS` | `localhost,127.0.0.1` | Hosts permitidos |

## Compilar CSS (Tailwind + Flowbite)

O script já executa a compilação inicial. Durante o desenvolvimento, mantenha
o watcher aberto em outro terminal para recompilar o CSS após cada alteração:

```bash
cd meu_projeto
npm run css:watch
```

Para gerar uma versão minificada uma única vez:

```bash
npm run build
```

Consulte a [documentação do Flowbite para Django](https://flowbite.com/docs/getting-started/django/) para conhecer a integração e os componentes disponíveis.

## Solução de problemas

### Porta 8000 em uso

Identifique o processo que está usando a porta padrão do Django:

```bash
lsof -nP -iTCP:8000 -sTCP:LISTEN
```

Se a porta estiver publicada por um container Docker, localize-o e pare apenas
o container correspondente:

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}\t{{.Status}}'
docker stop nome_do_container
```

Como alternativa, inicie o Django em outra porta:

```bash
uv run python manage.py runserver 8001
```
