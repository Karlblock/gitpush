#!/bin/bash

# Script pour créer différents types de démos
# Usage: ./create_demo.sh [gif|png|svg|asciinema]

DEMO_TYPE="${1:-all}"

echo "🎬 Création des démos gitpush v0.4.0..."

case "$DEMO_TYPE" in
  "gif"|"all")
    echo "📹 Création du GIF de démo..."
    if command -v asciinema &> /dev/null && command -v agg &> /dev/null; then
      # Enregistrement avec asciinema puis conversion en GIF
      asciinema rec demo_main.cast -c "./demo.sh" --overwrite
      agg demo_main.cast demo_main.gif
      echo "✅ GIF créé : demo_main.gif"
    else
      echo "⚠️ asciinema ou agg non installé. Utilisez : npm install -g @asciinema/agg"
    fi
    ;;
    
  "png"|"all")
    echo "📸 Création des captures PNG..."
    if command -v gnome-screenshot &> /dev/null; then
      echo "Lancement de la démo dans 3 secondes..."
      sleep 3
      gnome-terminal -- bash -c "./demo.sh; sleep 5" &
      sleep 2
      gnome-screenshot -w -f demo_main.png
      echo "✅ PNG créé : demo_main.png"
    else
      echo "⚠️ gnome-screenshot non disponible. Utilisez votre outil de capture préféré."
    fi
    ;;
    
  "svg"|"all")
    echo "🎨 Création du SVG avec termtosvg..."
    if command -v termtosvg &> /dev/null; then
      termtosvg demo_main.svg -c "./demo.sh"
      echo "✅ SVG créé : demo_main.svg"
    else
      echo "⚠️ termtosvg non installé. Utilisez : pip install termtosvg"
    fi
    ;;
    
  "asciinema"|"all")
    echo "🎥 Enregistrement asciinema..."
    if command -v asciinema &> /dev/null; then
      echo "Enregistrement du workflow principal..."
      asciinema rec demo_main.cast -c "./demo.sh" --overwrite
      echo "Enregistrement de la gestion des issues..."
      asciinema rec demo_issues.cast -c "./demo_issues.sh" --overwrite
      echo "✅ Casts créés : demo_main.cast, demo_issues.cast"
      echo "🌐 Uploadez sur asciinema.org avec : asciinema upload demo_main.cast"
    else
      echo "⚠️ asciinema non installé"
    fi
    ;;
    
  "carbon")
    echo "💎 Instructions pour Carbon.now.sh :"
    echo "1. Allez sur https://carbon.now.sh"
    echo "2. Collez ce code :"
    cat << 'CODE'
$ gitpush
📍 Branche actuelle : feature/new-login
✏️ Message de commit : fix: resolve authentication timeout issue #42
🔗 Détection automatique : ce commit pourrait fermer l'issue #42
❓ Confirmer la fermeture de l'issue #42 ? (y/N) : y
📦 Résumé de l'action :
• 📝 Commit : fix: resolve authentication timeout issue #42
• 🔄 Pull : activé  • 🏷️ Tag : auto  • 🚀 Release : oui
• 🔒 Fermer issue : #42
✅ Workflow terminé avec succès ! 🎉
CODE
    echo "3. Configurez le thème (recommandé: Dracula ou Nord)"
    echo "4. Exportez l'image"
    ;;
    
  *)
    echo "❌ Usage: $0 [gif|png|svg|asciinema|carbon|all]"
    exit 1
    ;;
esac

echo "📁 Fichiers de démo disponibles :"
ls -la *.{gif,png,svg,cast} 2>/dev/null || echo "Aucun fichier de démo encore créé"

echo ""
echo "🚀 Démos gitpush v0.4.0 prêtes !"
echo "💡 Pour le README, utilisez l'une de ces images ou le lien asciinema"