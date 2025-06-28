#!/bin/bash

# Demo script for gitpush AI features v0.5.0

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m"

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

echo -e "${CYAN}🔧 Gitpush - Assistant Git interactif ${MAGENTA}v0.5.0-dev${NC}"
echo -e "${GREEN}✨ Avec Intelligence Artificielle !${NC}"
sleep 1

echo -e "\n📍 Branche actuelle : ${MAGENTA}feature/ai-integration${NC}"
echo -e "📦 Dépôt : ${CYAN}gitpush${NC}"
sleep 1

echo -e "\n${MAGENTA}🎯 Menu Principal${NC}"
echo "1) 🚀 Workflow Git complet"
echo "2) 📋 Gestion des Issues"
echo -e "${GREEN}3) 🤖 Assistant AI${NC} ${YELLOW}← NOUVEAU !${NC}"
echo "4) ❌ Quitter"
echo
echo -n "👉 Ton choix : "
sleep 1
echo "3"
sleep 0.5

echo -e "\n${MAGENTA}🤖 Mode AI Interactif${NC}"
echo "1) 📝 Générer un message de commit"
echo "2) 🔍 Analyser le code avant commit"
echo "3) 🌿 Suggérer un nom de branche"
echo "4) 💡 Expliquer un diff"
echo "5) 🔧 Configurer l'AI"
echo "6) 🔙 Retour"
echo
echo -n "👉 Que veux-tu faire avec l'AI ? "
sleep 1
echo "1"
sleep 0.5

echo -e "\n${CYAN}🤖 Analyse des changements avec AI...${NC}"
sleep 2

echo -e "${GREEN}✨ Suggestion AI :${NC} feat(ai): implement smart commit message generation with OpenAI integration"
echo
echo -n "✏️ Utiliser ce message ou modifier [Enter pour accepter] : "
sleep 1
echo ""
sleep 0.5

echo -e "\n${GREEN}✅ Message accepté !${NC}"
sleep 1

echo -e "\n--- Demo AI Commit avec gitpush ---"
echo
echo "$ gitpush --ai-commit"
echo
echo -e "${CYAN}🤖 Génération du message avec AI...${NC}"
echo -e "Analyse de 3 fichiers modifiés..."
echo -e "${GREEN}📝 Suggestion AI : ${NC}refactor(lib): extract AI logic to separate module for better maintainability"
echo
echo "📦 Workflow complet avec AI !"
sleep 2

echo -e "\n${MAGENTA}✨ Gitpush v0.5.0 - L'IA au service de Git ! ✨${NC}"