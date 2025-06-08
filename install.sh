#!/bin/bash

echo "📦 Installation de gitpush..."

SCRIPT_DIR="$HOME/.scripts"
TARGET="$SCRIPT_DIR/gitpush.sh"
ALIAS='alias gitpush="$HOME/.scripts/gitpush.sh"'
SHELL_RC="$HOME/.bashrc"

# Detect shell
if [[ "$SHELL" =~ zsh$ ]]; then
  SHELL_RC="$HOME/.zshrc"
fi

# Créer le dossier si besoin
mkdir -p "$SCRIPT_DIR"

# Télécharger le script
curl -fsSL https://raw.githubusercontent.com/karlblock/gitpush/main/gitpush.sh -o "$TARGET"
chmod +x "$TARGET"

# Ajouter alias s’il n’existe pas déjà
if ! grep -Fxq "$ALIAS" "$SHELL_RC"; then
  echo "$ALIAS" >> "$SHELL_RC"
  echo "✅ Alias ajouté à $SHELL_RC"
else
  echo "ℹ️ Alias déjà présent dans $SHELL_RC"
fi

# Export version (optionnel)
if ! grep -q "export GITPUSH_VERSION=" "$SHELL_RC"; then
  echo 'export GITPUSH_VERSION="v0.3.1"' >> "$SHELL_RC"
fi

# Charger immédiatement
source "$SHELL_RC"

echo "🚀 Gitpush est prêt à l’emploi !"
echo "ℹ️ Tape 'gitpush' dans ton terminal ✨"
