#!/bin/bash
# setup_githooks.sh
# Erstellt einen Repo-eigenen .githooks Ordner und aktiviert ihn

set -e

echo "⚡ Richte Repo-eigene Git-Hooks ein..."

# Ordner anlegen
mkdir -p .githooks

# Falls ein pre-commit Hook existiert, verschieben
if [ -f ".git/hooks/pre-commit" ]; then
  echo "📦 Verschiebe bestehenden pre-commit Hook nach .githooks/"
  mv .git/hooks/pre-commit .githooks/pre-commit
fi

# Git Config setzen
git config core.hooksPath .githooks

# Hook ausführbar machen (für Unix-Systeme)
chmod +x .githooks/pre-commit || true

echo "✅ Setup abgeschlossen. Hooks liegen jetzt in .githooks/ und sind versioniert."

