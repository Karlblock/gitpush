#!/bin/bash

# 🤖 AI Conflict Resolver for Gitpush
# Smart merge conflict resolution using AI

source "$(dirname "${BASH_SOURCE[0]}")/ai_manager.sh"

# Resolve merge conflicts with AI
resolve_conflicts_with_ai() {
  local conflicted_files=$(git diff --name-only --diff-filter=U)
  
  if [[ -z "$conflicted_files" ]]; then
    echo -e "${GREEN}✅ Aucun conflit détecté !${NC}"
    return 0
  fi
  
  echo -e "${YELLOW}⚔️ Conflits détectés dans :${NC}"
  echo "$conflicted_files"
  echo
  
  for file in $conflicted_files; do
    echo -e "${CYAN}🔍 Analyse de $file...${NC}"
    
    # Extract conflict markers
    local ours=$(sed -n '/<<<<<<< HEAD/,/=======/p' "$file" | sed '1d;$d')
    local theirs=$(sed -n '/=======/,/>>>>>>>/p' "$file" | sed '1d;$d')
    
    if [[ $(check_ai_available) == "true" ]]; then
      echo -e "${CYAN}🤖 Résolution AI en cours...${NC}"
      
      local prompt="Merge conflict resolution needed. 
      Current branch code: $ours
      Incoming branch code: $theirs
      
      Provide the best merged version that preserves functionality from both."
      
      local resolution=$(generate_commit_message "$prompt" 2>/dev/null)
      
      if [[ -n "$resolution" ]]; then
        echo -e "${GREEN}✨ Suggestion AI :${NC}"
        echo "$resolution"
        
        read -p "❓ Appliquer cette résolution ? (y/N) : " apply
        if [[ "$apply" =~ ^[yY]$ ]]; then
          # Apply resolution
          echo "$resolution" > "$file.resolved"
          echo -e "${GREEN}✅ Résolution appliquée dans $file.resolved${NC}"
        fi
      fi
    else
      echo -e "${YELLOW}⚠️ AI non disponible. Résolution manuelle requise.${NC}"
      show_manual_resolution_guide "$file"
    fi
  done
}

# Show manual resolution guide
show_manual_resolution_guide() {
  local file="$1"
  
  echo -e "\n${MAGENTA}📖 Guide de résolution manuelle :${NC}"
  echo "1. Ouvrir $file dans ton éditeur"
  echo "2. Chercher les marqueurs <<<<<<<, =======, >>>>>>>"
  echo "3. Décider quelle version garder ou merger"
  echo "4. Supprimer les marqueurs de conflit"
  echo "5. git add $file"
  echo "6. git commit"
}

# Interactive conflict resolution
interactive_conflict_resolution() {
  local file="$1"
  
  echo -e "\n${MAGENTA}🎯 Résolution interactive de $file${NC}"
  PS3=$'\n👉 Que faire ? '
  options=(
    "👆 Garder notre version (HEAD)"
    "👇 Garder leur version (incoming)"
    "🤝 Merger manuellement"
    "🤖 Demander à l'AI"
    "⏭️ Passer ce fichier"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        git checkout --ours "$file"
        git add "$file"
        echo -e "${GREEN}✅ Notre version gardée${NC}"
        break
        ;;
      2)
        git checkout --theirs "$file"
        git add "$file"
        echo -e "${GREEN}✅ Leur version gardée${NC}"
        break
        ;;
      3)
        echo -e "${CYAN}🔧 Ouvre ton éditeur pour merger manuellement${NC}"
        ${EDITOR:-nano} "$file"
        break
        ;;
      4)
        resolve_conflicts_with_ai
        break
        ;;
      5)
        echo -e "${YELLOW}⏭️ Fichier passé${NC}"
        break
        ;;
    esac
  done
}

# Main conflict resolver
conflict_resolver_menu() {
  echo -e "\n${MAGENTA}⚔️ Résolution de Conflits AI${NC}"
  
  local conflicted_files=$(git diff --name-only --diff-filter=U)
  if [[ -z "$conflicted_files" ]]; then
    echo -e "${GREEN}✅ Aucun conflit à résoudre !${NC}"
    return 0
  fi
  
  echo -e "${YELLOW}Fichiers en conflit :${NC}"
  echo "$conflicted_files"
  
  PS3=$'\n👉 Action ? '
  options=(
    "🤖 Résoudre tout avec AI"
    "🎯 Résolution interactive"
    "📚 Guide de résolution"
    "🔙 Retour"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        resolve_conflicts_with_ai
        ;;
      2)
        for file in $conflicted_files; do
          interactive_conflict_resolution "$file"
        done
        ;;
      3)
        show_manual_resolution_guide
        ;;
      4)
        break
        ;;
    esac
  done
}

export -f resolve_conflicts_with_ai
export -f conflict_resolver_menu