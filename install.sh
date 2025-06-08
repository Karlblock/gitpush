#!/bin/bash
set -e

echo "📦 Installation de gitpush..."

# Répertoires cibles
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
SCRIPT_NAME="gitpush"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Créer le dossier d'installation
mkdir -p "$INSTALL_DIR"

# Télécharger le script principal
curl -fsSL https://raw.githubusercontent.com/Karlblock/gitpush/main/gitpush.sh -o "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

# Ajouter à $PATH si non présent
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  SHELL_CONFIG=""
  [[ -f "$HOME/.bashrc" ]] && SHELL_CONFIG="$HOME/.bashrc"
  [[ -f "$HOME/.zshrc" ]] && SHELL_CONFIG="$HOME/.zshrc"

  if [[ -n "$SHELL_CONFIG" ]]; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_CONFIG"
    echo "✅ PATH mis à jour dans $SHELL_CONFIG"
    source "$SHELL_CONFIG"
  else
    echo "⚠️ Impossible de trouver un fichier de configuration shell (.bashrc ou .zshrc)"
  fi
fi

# Création du lanceur graphique
if command -v xdg-open &> /dev/null; then
  mkdir -p "$DESKTOP_DIR"

  cat > "$DESKTOP_DIR/gitpush.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Gitpush
Exec=$SCRIPT_PATH
Icon=utilities-terminal
Terminal=true
Categories=Development;
EOF

  chmod +x "$DESKTOP_DIR/gitpush.desktop"
  update-desktop-database "$DESKTOP_DIR" &> /dev/null || true
  echo "🖥️ Lanceur graphique installé (menu Applications > Gitpush)"
fi

echo "🚀 Gitpush v3.0.0 est prêt à l’emploi !"
echo "✨ Tape simplement : \033[1;32mgitpush\033[0m"
