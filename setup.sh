#!/bin/bash
# setup_githooks.sh
# Erstellt einen Repo-eigenen .githooks Ordner und aktiviert ihn
# Prüft zusätzlich auf lokale Firebase-Konfigurationsdateien (STRIKT)

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

# -------------------------
# Firebase Config Check (STRIKT)
# -------------------------
echo "🔍 Prüfe Firebase-Konfigurationsdateien..."

missing=false

for file in \
  "lib/firebase_options.dart" \
  "lib/firebase_options_dev.dart" \
  "android/app/google-services.json" \
  "android/app/google-services_dev.json" \
  "ios/Runner/GoogleService-Info.plist" \
  "ios/Runner/GoogleService-Info_dev.plist"
do
  if [ ! -f "$file" ]; then
    echo "❌ Datei fehlt: $file"
    missing=true
  fi
done

if [ "$missing" = true ]; then
  echo "🚨 Setup abgebrochen: Bitte lade die fehlenden Firebase-Dateien aus der Firebase Console herunter!"
  exit 1
else
  echo "✅ Alle Firebase-Dateien vorhanden."
fi
