#!/bin/bash
set -e

# Cores
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}${CYAN}"
echo "  ██████╗      ██╗ █████╗ ███╗   ██╗ ██████╗  ██████╗"
echo "  ██╔══██╗     ██║██╔══██╗████╗  ██║██╔════╝ ██╔═══██╗"
echo "  ██║  ██║     ██║███████║██╔██╗ ██║██║  ███╗██║   ██║"
echo "  ██║  ██║██   ██║██╔══██║██║╚██╗██║██║   ██║██║   ██║"
echo "  ██████╔╝╚█████╔╝██║  ██║██║ ╚████║╚██████╔╝╚██████╔╝"
echo "  ╚═════╝  ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝"
echo -e "${RESET}"
echo -e "  ${BOLD}Django Starter${RESET} — ${YELLOW}uv + htmx + alpine + daisyui + allauth${RESET}"
echo ""

if [ -n "$1" ]; then
    PROJECT="$1"
else
    echo -e -n "  ${BOLD}Nome do projeto:${RESET} "
    read -r PROJECT
    [ -z "$PROJECT" ] && { echo "Nome não pode ser vazio."; exit 1; }
fi

echo -e -n "  ${BOLD}Criar apps? (s/N):${RESET} "
read -r CREATE_APPS_ANSWER
APPS=()

if [[ "$CREATE_APPS_ANSWER" =~ ^[sS]$ ]]; then
    while true; do
        echo -e -n "  ${BOLD}Nome do app (vazio para encerrar):${RESET} "
        read -r APP_NAME
        [ -z "$APP_NAME" ] && break
        APPS+=("$APP_NAME")
    done
fi
echo ""

# --- Criação do projeto ---
uv init "$PROJECT"
cd "$PROJECT"

uv add django django-environ django-cotton django-htmx django-allauth django-debug-toolbar django-browser-reload whitenoise django-tabler-icons pillow

uv run django-admin startproject config .

mkdir -p static/css static/js templates/cotton templates/home

# --- HTMX ---
echo "Baixando HTMX..."
curl -sL https://cdn.jsdelivr.net/npm/htmx.org@2.x.x/dist/htmx.min.js -o static/js/htmx.min.js

# --- Alpine.js ---
echo "Baixando Alpine.js..."
curl -sL https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js -o static/js/alpine.min.js

# --- DaisyUI (inclui Tailwind CLI) ---
echo "Instalando DaisyUI + Tailwind..."
(cd static/css && curl -sL daisyui.com/fast | bash)

# --- Template base ---
cat > templates/base.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}App{% endblock %}</title>
    {% load static %}
    <link href="{% static 'css/output.css' %}" rel="stylesheet" />
    <script src="{% static 'js/htmx.min.js' %}"></script>
    <script defer src="{% static 'js/alpine.min.js' %}"></script>
</head>
<body>
    {% block content %}{% endblock %}
</body>
</html>
EOF

# --- .env ---
cat > .env << 'EOF'
DEBUG=True
SECRET_KEY=django-insecure-troque-em-producao
ALLOWED_HOSTS=localhost,127.0.0.1
EOF

cat > .env.example << 'EOF'
DEBUG=True
SECRET_KEY=sua-secret-key-aqui
ALLOWED_HOSTS=localhost,127.0.0.1
EOF

# --- .gitignore ---
cat >> .gitignore << 'EOF'

# Environment variables
.env

# Static compilado
static/css/tailwindcss
static/css/daisyui*.mjs
static/css/output.css
staticfiles/
EOF

# --- settings.py ---
cat > config/settings.py << 'EOF'
from pathlib import Path

import environ

BASE_DIR = Path(__file__).resolve().parent.parent

env = environ.Env(
    DEBUG=(bool, True),
    ALLOWED_HOSTS=(list, []),
)
environ.Env.read_env(BASE_DIR / ".env")

SECRET_KEY = env("SECRET_KEY", default="django-insecure-troque-em-producao")
DEBUG = env("DEBUG")
ALLOWED_HOSTS = env("ALLOWED_HOSTS")

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django_cotton",
    "django_htmx",
    "allauth",
    "allauth.account",
    "debug_toolbar",
    "django_browser_reload",
    "tabler_icons",
    # EXTRA_APPS
]

AUTHENTICATION_BACKENDS = [
    "django.contrib.auth.backends.ModelBackend",
    "allauth.account.auth_backends.AuthenticationBackend",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "debug_toolbar.middleware.DebugToolbarMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "django_htmx.middleware.HtmxMiddleware",
    "allauth.account.middleware.AccountMiddleware",
    "django_browser_reload.middleware.BrowserReloadMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

LANGUAGE_CODE = "pt-br"
TIME_ZONE = "America/Sao_Paulo"
USE_I18N = True
USE_TZ = True

INTERNAL_IPS = ["127.0.0.1"]

STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_DIRS = [BASE_DIR / "static"]
STORAGES = {
    "staticfiles": {
        "BACKEND": "whitenoise.storage.CompressedManifestStaticFilesStorage",
    },
}

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

LOGIN_REDIRECT_URL = "/"
EOF

# --- views.py ---
cat > config/views.py << 'EOF'
from django.contrib.auth.decorators import login_required
from django.shortcuts import render


@login_required
def home(request):
    return render(request, "home/index.html")
EOF

# --- Template home ---
cat > templates/home/index.html << 'EOF'
{% extends "base.html" %}

{% block title %}Home{% endblock %}

{% block content %}
<div class="flex items-center justify-center min-h-screen">
    <p class="text-xl">Olá, {{ user.username }}!</p>
</div>
{% endblock %}
EOF

# --- urls.py ---
cat > config/urls.py << 'EOF'
from django.contrib import admin
from django.urls import include, path

from config.views import home

urlpatterns = [
    path("", home, name="home"),
    path("admin/", admin.site.urls),
    path("accounts/", include("allauth.urls")),
    path("__reload__/", include("django_browser_reload.urls")),
    # EXTRA_URLS
]

from django.conf import settings

if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [path("__debug__/", include(debug_toolbar.urls))] + urlpatterns
EOF

# --- Apps ---
if [ ${#APPS[@]} -gt 0 ]; then
    mkdir -p apps
    touch apps/__init__.py

    for app in "${APPS[@]}"; do
        uv run python manage.py startapp "$app" "apps/$app"
        sed -i "s/name = '$app'/name = 'apps.$app'/" "apps/$app/apps.py"
        cat > "apps/$app/urls.py" << APPEOF
from django.urls import path

app_name = "$app"

urlpatterns = []
APPEOF
        sed -i "s|    # EXTRA_APPS|    \"apps.$app\",\n    # EXTRA_APPS|" config/settings.py
        sed -i "s|    # EXTRA_URLS|    path(\"$app/\", include(\"apps.$app.urls\")),\n    # EXTRA_URLS|" config/urls.py
        echo -e "  ${GREEN}✓ App '$app' criado${RESET}"
    done
fi

sed -i "/    # EXTRA_APPS/d" config/settings.py
sed -i "/    # EXTRA_URLS/d" config/urls.py

# --- Migrate ---
uv run python manage.py migrate

echo ""
echo -e "${GREEN}${BOLD}✓ Projeto '$PROJECT' criado com sucesso!${RESET}"
echo -e "  Para iniciar: ${CYAN}cd $PROJECT && uv run python manage.py runserver${RESET}"
