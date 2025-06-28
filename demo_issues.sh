#!/bin/bash

# Demo script for gitpush issues management
# Simulates the issues workflow

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

pause() {
  sleep "${1:-1}"
}

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

echo -e "\n📍 Branche actuelle : ${MAGENTA}main${NC}"
echo -e "📦 Dépôt : ${CYAN}gitpush${NC}"
pause 1

echo -e "\n${MAGENTA}🎯 Gestion des Issues GitHub${NC}"
echo "1) 📋 Lister les issues ouvertes"
echo "2) ➕ Créer une nouvelle issue"
echo "3) 🔒 Fermer une issue"
echo "4) 🏷️ Gestion des labels"
echo "5) 🔙 Retour au menu principal"
echo
echo -n "👉 Ton choix : "
pause 1
echo "2"
pause 0.5

echo -e "\n${GREEN}➕ Création d'une nouvelle issue${NC}"
echo -n "📝 Titre de l'issue : "
pause 1
type_text "Add dark mode support for UI components" 0.03
pause 0.5

echo -n "📄 Description (optionnel) : "
pause 1
type_text "Implement dark theme toggle with localStorage persistence" 0.03
pause 0.5

echo -e "\n🏷️ Labels disponibles :"
echo -e "  ${YELLOW}1.${NC} bug"
echo -e "  ${YELLOW}2.${NC} enhancement"
echo -e "  ${YELLOW}3.${NC} feature"
echo -e "  ${YELLOW}4.${NC} documentation"
echo -e "  ${YELLOW}5.${NC} question"
echo -e "  ${YELLOW}6.${NC} help wanted"
echo -e "  ${YELLOW}7.${NC} good first issue"
pause 1

echo -n "🔖 Numéros des labels (ex: 1,3,5) ou personnalisés (ex: urgent,backend) : "
pause 1
echo "2,3"
pause 0.5

echo -e "${CYAN}Executing:${NC} gh issue create --title \"Add dark mode support for UI components\" --body \"Implement dark theme toggle with localStorage persistence\" --label \"enhancement\" --label \"feature\""
pause 1
echo -e "${GREEN}✅ Issue créée avec succès !${NC}"
echo -e "${CYAN}🔗 https://github.com/Karlblock/gitpush/issues/43${NC}"
pause 2

echo -e "\n${MAGENTA}🎯 Gestion des Issues GitHub${NC}"
echo "1) 📋 Lister les issues ouvertes"
echo "2) ➕ Créer une nouvelle issue"
echo "3) 🔒 Fermer une issue"
echo "4) 🏷️ Gestion des labels"
echo "5) 🔙 Retour au menu principal"
echo
echo -n "👉 Ton choix : "
pause 1
echo "1"
pause 0.5

echo -e "\n${CYAN}📋 Issues ouvertes :${NC}"
echo "#42 Fix authentication timeout [bug]"
echo "#43 Add dark mode support for UI components [enhancement, feature]"
echo "#41 Update documentation for v0.4.0 [documentation]"
echo "#40 Improve error handling in git operations [enhancement]"
pause 2

echo -e "\n${GREEN}🎉 Gestion des issues terminée !${NC}"
echo -e "${MAGENTA}✨ Interface intuitive pour une communauté productive ! ✨${NC}"