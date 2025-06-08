#!/bin/bash

echo "📦 Installation de gitpush..."

mkdir -p ~/.scripts
curl -sSL https://raw.githubusercontent.com/<ton-user>/gopush/main/gitpush.sh -o ~/.scripts/gitpush.sh
chmod +x ~/.scripts/gitpush.sh

if ! grep -q "alias gopush=" ~/.bashrc; then
  echo 'alias gitpush="~/.scripts/gitpush.sh"' >> ~/.bashrc
  echo "✅ Alias ajouté à ~/.bashrc"
fi

source ~/.bashrc
echo "🚀 Gitpush est prêt à l’emploi !"

