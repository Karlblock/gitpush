#!/bin/bash

# Demo script for gitpush v0.4.0
# Simulates a real interaction with delays and colors

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
NC="\033[0m"

# Helper function to simulate typing
type_text() {
  local text="$1"
  local delay="${2:-0.05}"
  
  for (( i=0; i<${#text}; i++ )); do
    printf "${text:$i:1}"
    sleep "$delay"
  done
  printf "\n"
}

# Helper function to pause
pause() {
  sleep "${1:-1}"
}

# Clear screen and show banner
clear
cat << "EOF"
          _ __                   __  
   ____ _(_) /_____  __  _______/ /_ 
  / __ `/ / __/ __ \/ / / / ___/ __ \
 / /_/ / / /_/ /_/ / /_/ (__  ) / / / 
 \__, /_/\__/ .___/\__,_/____/_/ /_/  
/____/     /_/                        

        🚀 gitpush — by Karl Block
EOF

echo -e "${CYAN}🔧 Gitpush - Assistant Git interactif ${MAGENTA}v0.4.0-dev${NC}"
pause 1

echo -e "\n📍 Branche actuelle : ${MAGENTA}feature/new-login${NC}"
echo -e "📦 Dépôt : ${CYAN}gitpush${NC}"
pause 1

echo -e "\n${MAGENTA}🎯 Menu Principal${NC}"
echo "1) 🚀 Workflow Git complet"
echo "2) 📋 Gestion des Issues"
echo "3) ❌ Quitter"
echo
echo -n "👉 Ton choix : "
pause 1
echo "1"
pause 0.5

echo -n "✏️ Message de commit : "
pause 1
type_text "fix: resolve authentication timeout issue #42" 0.03
pause 0.5

echo -e "${YELLOW}🔗 Détection automatique : ce commit pourrait fermer l'issue #42${NC}"
echo -n "❓ Confirmer la fermeture de l'issue #42 ? (y/N) : "
pause 1
echo "y"
pause 0.5

echo -e "${YELLOW}🐛 Ce commit semble corriger un bug.${NC}"
echo -n "❓ Créer une issue de suivi ? (y/N) : "
pause 1
echo "n"
pause 0.5

echo -n "🔄 Faire un pull --rebase avant ? (y/N) : "
pause 1
echo "y"
pause 0.3

echo -n "🏷️  Créer un tag ? (y/N) : "
pause 1
echo "y"
pause 0.3

echo -n "🚀 Créer une GitHub Release ? (y/N) : "
pause 1
echo "y"
pause 0.3

echo -n "🎯 Accéder au menu Issues ? (y/N) : "
pause 1
echo "n"
pause 1

echo -e "\n📦 Résumé de l'action :"
echo -e "• 📝 Commit : ${GREEN}fix: resolve authentication timeout issue #42${NC}"
echo -e "• 🔄 Pull : ${CYAN}activé${NC}"
echo -e "• 🏷️  Tag : ${YELLOW}auto${NC}"
echo -e "• 🚀 Release : ${CYAN}oui${NC}"
echo -e "• 🔒 Fermer issue : ${YELLOW}#42${NC}"
pause 1

echo -n $'\n✅ Confirmer et lancer ? (y/N) : '
pause 1
echo "y"
pause 0.5

echo -e "\n${CYAN}Executing:${NC} git add ."
pause 0.3
echo -e "${CYAN}Executing:${NC} git commit -m 'fix: resolve authentication timeout issue #42'"
pause 0.3
echo -e "${CYAN}Executing:${NC} git pull --rebase"
pause 0.3
echo -e "${CYAN}Executing:${NC} git push"
pause 0.3
echo -e "${CYAN}Executing:${NC} gh issue close 42 --comment 'Fixed by commit: fix: resolve authentication timeout issue #42'"
echo -e "${GREEN}✅ Issue #42 fermée automatiquement !${NC}"
pause 0.5
echo -e "${CYAN}Executing:${NC} git tag v0.4.0"
echo -e "${CYAN}Executing:${NC} git push origin v0.4.0"
echo -e "${GREEN}✅ Tag v0.4.0 ajouté et poussé.${NC}"
pause 0.5
echo -e "${CYAN}Executing:${NC} gh release create v0.4.0 --title v0.4.0 --generate-notes"
echo -e "${GREEN}✅ Release GitHub créée !${NC}"
pause 1

echo -e "\n${GREEN}🎉 Workflow terminé avec succès !${NC}"
echo -e "${CYAN}🌐 Ouverture de GitHub...${NC}"
pause 2

echo -e "\n${MAGENTA}✨ gitpush v0.4.0 - Machine de guerre pour la communauté ! ✨${NC}"