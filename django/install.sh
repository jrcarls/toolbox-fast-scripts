#!/bin/bash
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/setup_django.sh"
INSTALL_DIR="${TOOLBOX_BIN_DIR:-$HOME/.local/bin}"
TARGET="$INSTALL_DIR/setup-django"

mkdir -p "$INSTALL_DIR"

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$SOURCE" ]; then
    echo "O comando setup-django já está instalado."
elif [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "Não foi possível instalar: $TARGET já existe." >&2
    exit 1
else
    ln -s "$SOURCE" "$TARGET"
    echo "Comando instalado em $TARGET"
fi

case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *)
        echo ""
        echo "Adicione o diretório ao PATH com:"
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
        echo "  source ~/.bashrc"
        ;;
esac

echo ""
echo "Use em qualquer diretório: setup-django nome_do_projeto"
