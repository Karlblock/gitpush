#!/bin/bash

echo "📦 Installation de gopush..."

mkdir -p ~/.scripts
curl -sSL https://raw.githubusercontent.com/<ton-user>/gopush/main/gopush.sh -o ~/.scripts/gopush.sh
chmod +x ~/.scripts/gopush.sh

if ! grep -q "alias gopush=" ~/.bashrc; then
  echo 'alias gopush="~/.scripts/gopush.sh"' >> ~/.bashrc
  echo "✅ Alias ajouté à ~/.bashrc"
fi

source ~/.bashrc
echo "🚀 Gopush est prêt à l’emploi !"

