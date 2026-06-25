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
| [DaisyUI](https://daisyui.com/) + [Tailwind CSS](https://tailwindcss.com/) | Componentes e utilitários CSS |

## O que o script faz

1. Cria o projeto com `uv init` e instala todas as dependências
2. Inicializa a estrutura Django com `django-admin startproject config .`
3. Cria a estrutura de diretórios:
   ```
   static/
   ├── css/     # Tailwind/DaisyUI compilado
   └── js/      # HTMX e Alpine.js
   templates/
   ├── base.html
   └── cotton/  # Componentes django-cotton
   ```
4. Baixa HTMX e Alpine.js localmente (sem dependência de CDN em produção)
5. Instala DaisyUI + Tailwind CLI em `static/css/`
6. Gera `templates/base.html` com HTMX, Alpine.js e Tailwind já conectados
7. Gera `.env` e `.env.example` com configurações iniciais
8. Atualiza `.gitignore` com arquivos gerados e sensíveis
9. Gera `config/settings.py` completamente configurado com todos os apps e middlewares
10. Executa `migrate` inicial

## Pré-requisitos

- [`uv`](https://docs.astral.sh/uv/getting-started/installation/) instalado
- `curl` disponível no sistema

## Como usar

### Passando o nome do projeto como argumento

```bash
bash setup_django.sh meu_projeto
```

### Modo interativo (sem argumento)

```bash
bash setup_django.sh
# Nome do projeto: meu_projeto
```

### Após a execução

```bash
cd meu_projeto
uv run python manage.py runserver
```

## Estrutura gerada

```
meu_projeto/
├── config/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── static/
│   ├── css/
│   │   ├── tailwindcss      # CLI do Tailwind (no .gitignore)
│   │   ├── daisyui*.mjs     # (no .gitignore)
│   │   └── output.css       # CSS compilado (no .gitignore)
│   └── js/
│       ├── htmx.min.js
│       └── alpine.min.js
├── templates/
│   ├── base.html
│   └── cotton/              # Componentes django-cotton
├── .env                     # (no .gitignore)
├── .env.example
├── .gitignore
├── manage.py
└── pyproject.toml
```

## Variáveis de ambiente (.env)

| Variável | Padrão | Descrição |
|---|---|---|
| `DEBUG` | `True` | Modo debug |
| `SECRET_KEY` | insecure key | Chave secreta do Django — troque em produção |
| `ALLOWED_HOSTS` | `localhost,127.0.0.1` | Hosts permitidos |

## Compilar CSS (Tailwind + DaisyUI)

Após criar o projeto, compile o CSS para que os estilos funcionem:

```bash
cd meu_projeto/static/css
./tailwindcss -i <arquivo_entrada.css> -o output.css --watch
```

Consulte a [documentação do DaisyUI](https://daisyui.com/docs/install/) para o setup completo do Tailwind.
