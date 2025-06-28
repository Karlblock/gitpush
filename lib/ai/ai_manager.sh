#!/bin/bash

# 🤖 Gitpush AI Manager
# Handles all AI-related features for smart commits, reviews, etc.

# Colors (duplicate from main script to avoid circular dependency)
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m"

# AI Providers configuration
declare -A AI_PROVIDERS=(
  ["openai"]="https://api.openai.com/v1/chat/completions"
  ["anthropic"]="https://api.anthropic.com/v1/messages"
  ["google"]="https://generativelanguage.googleapis.com/v1/models"
  ["local"]="http://localhost:11434/api/generate"
)

# --- Check AI availability ---
check_ai_available() {
  local provider="${AI_PROVIDER:-openai}"
  
  case "$provider" in
    "openai")
      [[ -n "${OPENAI_API_KEY}" ]] || { echo "false"; return 1; }
      ;;
    "anthropic")
      [[ -n "${ANTHROPIC_API_KEY}" ]] || { echo "false"; return 1; }
      ;;
    "google")
      [[ -n "${GOOGLE_API_KEY}" ]] || { echo "false"; return 1; }
      ;;
    "local")
      curl -s http://localhost:11434/api/tags >/dev/null 2>&1 || { echo "false"; return 1; }
      ;;
    *)
      echo "false"
      return 1
      ;;
  esac
  
  echo "true"
  return 0
}

# --- Generate commit message using AI ---
generate_commit_message() {
  local diff_content="$1"
  local provider="${AI_PROVIDER:-openai}"
  
  if [[ $(check_ai_available) == "false" ]]; then
    echo -e "${YELLOW}⚠️ AI non configuré. Utilise ${CYAN}export OPENAI_API_KEY=...${NC}"
    return 1
  fi
  
  echo -e "${CYAN}🤖 Analyse des changements avec AI...${NC}"
  
  # Prepare the prompt
  local prompt="Based on these git changes, generate a conventional commit message (feat/fix/docs/style/refactor/test/chore). Be concise and specific:\n\n$diff_content\n\nFormat: type(scope): description"
  
  local response=""
  
  case "$provider" in
    "openai")
      response=$(generate_openai_commit "$prompt")
      ;;
    "anthropic")
      response=$(generate_anthropic_commit "$prompt")
      ;;
    "google")
      response=$(generate_google_commit "$prompt")
      ;;
    "local")
      response=$(generate_local_commit "$prompt")
      ;;
  esac
  
  if [[ -n "$response" ]]; then
    echo -e "${GREEN}✨ Suggestion AI :${NC} $response"
    echo "$response"
    return 0
  else
    echo -e "${RED}❌ Erreur AI. Revenir au mode manuel.${NC}"
    return 1
  fi
}

# --- OpenAI implementation ---
generate_openai_commit() {
  local prompt="$1"
  
  local response=$(curl -s -X POST "${AI_PROVIDERS[openai]}" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{
      "model": "gpt-4",
      "messages": [
        {"role": "system", "content": "You are a Git commit message expert. Generate concise, conventional commit messages."},
        {"role": "user", "content": "'"$prompt"'"}
      ],
      "max_tokens": 100,
      "temperature": 0.3
    }' | jq -r '.choices[0].message.content' 2>/dev/null)
  
  echo "$response"
}

# --- Anthropic implementation ---
generate_anthropic_commit() {
  local prompt="$1"
  
  local response=$(curl -s -X POST "${AI_PROVIDERS[anthropic]}" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "Content-Type: application/json" \
    -d '{
      "model": "claude-3-haiku-20240307",
      "max_tokens": 100,
      "messages": [
        {"role": "user", "content": "'"$prompt"'"}
      ]
    }' | jq -r '.content[0].text' 2>/dev/null)
  
  echo "$response"
}

# --- Google Gemini implementation ---
generate_google_commit() {
  local prompt="$1"
  
  local response=$(curl -s -X POST "${AI_PROVIDERS[google]}/gemini-pro:generateContent?key=$GOOGLE_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{
      "contents": [{
        "parts": [{
          "text": "You are a Git commit message expert. Generate concise, conventional commit messages.\n\n'"$prompt"'"
        }]
      }],
      "generationConfig": {
        "temperature": 0.3,
        "maxOutputTokens": 100
      }
    }' | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)
  
  echo "$response"
}

# --- Local AI implementation (Ollama) ---
generate_local_commit() {
  local prompt="$1"
  
  local response=$(curl -s -X POST "${AI_PROVIDERS[local]}" \
    -d '{
      "model": "codellama",
      "prompt": "'"$prompt"'",
      "stream": false
    }' | jq -r '.response' 2>/dev/null)
  
  echo "$response"
}

# --- Analyze code for potential issues ---
analyze_code_pre_commit() {
  local files="$1"
  local provider="${AI_PROVIDER:-openai}"
  
  if [[ $(check_ai_available) == "false" ]]; then
    # Fallback to basic checks
    perform_basic_code_checks "$files"
    return $?
  fi
  
  echo -e "${CYAN}🔍 Analyse pre-commit avec AI...${NC}"
  
  local all_issues=()
  local security_score=100
  local quality_score=100
  
  # Analyze each file
  for file in $files; do
    if [[ -f "$file" ]] && [[ "$file" =~ \.(js|ts|py|sh|java|go|rs)$ ]]; then
      local file_content=$(head -n 500 "$file" 2>/dev/null)
      local analysis=$(analyze_single_file "$file" "$file_content")
      
      if [[ -n "$analysis" ]]; then
        all_issues+=("$analysis")
      fi
    fi
  done
  
  # Perform security analysis
  local security_issues=$(check_security_issues "$files")
  if [[ -n "$security_issues" ]]; then
    all_issues+=("$security_issues")
    ((security_score-=20))
  fi
  
  # Check code quality
  local quality_issues=$(check_code_quality "$files")
  if [[ -n "$quality_issues" ]]; then
    all_issues+=("$quality_issues")
    ((quality_score-=15))
  fi
  
  # Display results
  echo -e "\n${MAGENTA}📊 Résultats de l'analyse :${NC}"
  echo -e "🔒 Sécurité : ${security_score}%"
  echo -e "✨ Qualité : ${quality_score}%"
  
  if [[ ${#all_issues[@]} -gt 0 ]]; then
    echo -e "\n${YELLOW}⚠️ Problèmes détectés :${NC}"
    for issue in "${all_issues[@]}"; do
      echo -e "$issue"
    done
    
    echo -e "\n${CYAN}💡 Suggestions d'amélioration :${NC}"
    suggest_fixes "${all_issues[@]}"
    
    read -p "❓ Continuer malgré les problèmes ? (y/N) : " continue_anyway
    [[ "$continue_anyway" =~ ^[yY]$ ]] && return 0 || return 1
  fi
  
  echo -e "${GREEN}✅ Code excellent ! Aucun problème majeur détecté.${NC}"
  return 0
}

# --- Perform basic code checks without AI ---
perform_basic_code_checks() {
  local files="$1"
  local issues_found=()
  
  for file in $files; do
    if [[ -f "$file" ]]; then
      # Security checks
      if grep -qE "(api_key|password|secret|token|private_key)\s*=\s*[\"'][^\"']+[\"']" "$file"; then
        issues_found+=("  🔐 ${RED}[CRITICAL]${NC} Secret hardcodé dans $file")
      fi
      
      # Debug statements
      if grep -qE "(console\\.log|print\\(|println\\(|debugger|pdb\\.set_trace)" "$file"; then
        issues_found+=("  🐛 ${YELLOW}[WARNING]${NC} Debug statements dans $file")
      fi
      
      # TODO/FIXME
      local todos=$(grep -c "TODO\|FIXME\|HACK\|XXX" "$file" 2>/dev/null || echo 0)
      if [[ $todos -gt 3 ]]; then
        issues_found+=("  📝 ${YELLOW}[INFO]${NC} $todos TODO/FIXME dans $file")
      fi
      
      # Large files
      local lines=$(wc -l < "$file" 2>/dev/null || echo 0)
      if [[ $lines -gt 500 ]]; then
        issues_found+=("  📏 ${YELLOW}[INFO]${NC} Fichier très long ($lines lignes) : $file")
      fi
    fi
  done
  
  if [[ ${#issues_found[@]} -gt 0 ]]; then
    echo -e "${YELLOW}⚠️ Analyse basique (mode offline) :${NC}"
    printf '%s\n' "${issues_found[@]}"
    return 1
  fi
  
  return 0
}

# --- Check security issues ---
check_security_issues() {
  local files="$1"
  local security_patterns=(
    "eval\("
    "exec\("
    "__import__\("
    "subprocess\.call\("
    "os\.system\("
    "innerHTML\s*="
    "dangerouslySetInnerHTML"
    "curl.*\|.*sh"
    "wget.*\|.*sh"
  )
  
  for pattern in "${security_patterns[@]}"; do
    for file in $files; do
      if grep -qE "$pattern" "$file" 2>/dev/null; then
        echo -e "  🚨 ${RED}[SECURITY]${NC} Pattern dangereux '$pattern' dans $file"
      fi
    done
  done
}

# --- Check code quality ---
check_code_quality() {
  local files="$1"
  local quality_issues=""
  
  for file in $files; do
    if [[ -f "$file" ]]; then
      # Check for very long lines
      if grep -qE "^.{120,}$" "$file"; then
        quality_issues+="  📐 ${YELLOW}[STYLE]${NC} Lignes trop longues dans $file\n"
      fi
      
      # Check for inconsistent indentation
      if [[ "$file" =~ \.(js|ts|py)$ ]]; then
        local tabs=$(grep -c "^\t" "$file" 2>/dev/null || echo 0)
        local spaces=$(grep -c "^  " "$file" 2>/dev/null || echo 0)
        if [[ $tabs -gt 0 && $spaces -gt 0 ]]; then
          quality_issues+="  🔧 ${YELLOW}[STYLE]${NC} Indentation mixte dans $file\n"
        fi
      fi
    fi
  done
  
  echo -e "$quality_issues"
}

# --- Suggest fixes for issues ---
suggest_fixes() {
  local issues=("$@")
  
  for issue in "${issues[@]}"; do
    case "$issue" in
      *"Secret hardcodé"*)
        echo "  → Utiliser des variables d'environnement ou un fichier .env"
        ;;
      *"Debug statements"*)
        echo "  → Retirer les console.log/print avant le commit"
        ;;
      *"TODO/FIXME"*)
        echo "  → Créer des issues GitHub pour tracker les TODOs"
        ;;
      *"Pattern dangereux"*)
        echo "  → Revoir la sécurité du code, éviter eval/exec"
        ;;
      *"Lignes trop longues"*)
        echo "  → Formatter le code (prettier, black, etc.)"
        ;;
    esac
  done
}

# --- Generate branch name suggestion ---
suggest_branch_name() {
  local description="$1"
  local provider="${AI_PROVIDER:-openai}"
  
  if [[ $(check_ai_available) == "false" ]]; then
    # Fallback to simple generation
    local branch_name=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
    echo "feature/$branch_name"
    return 0
  fi
  
  local prompt="Generate a git branch name for this task: $description. Use format: type/short-description (types: feature, fix, chore, docs)"
  
  # Use AI to generate branch name
  local response=$(generate_openai_commit "$prompt" 2>/dev/null)
  
  if [[ -n "$response" ]]; then
    echo "$response" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9\/-]//g'
  else
    # Fallback
    local branch_name=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
    echo "feature/$branch_name"
  fi
}

# --- Interactive AI mode ---
ai_interactive_mode() {
  echo -e "${MAGENTA}🤖 Mode AI Interactif${NC}"
  
  PS3=$'\n👉 Que veux-tu faire avec l\'AI ? '
  options=(
    "📝 Générer un message de commit"
    "🔍 Analyser le code avant commit"
    "🌿 Suggérer un nom de branche"
    "💡 Expliquer un diff"
    "🔧 Configurer l'AI"
    "🔙 Retour"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        local diff=$(git diff --cached)
        if [[ -z "$diff" ]]; then
          diff=$(git diff)
        fi
        if [[ -n "$diff" ]]; then
          generate_commit_message "$diff"
        else
          echo -e "${YELLOW}⚠️ Aucune modification à analyser${NC}"
        fi
        ;;
      2)
        local files=$(git diff --cached --name-only)
        if [[ -z "$files" ]]; then
          files=$(git diff --name-only)
        fi
        analyze_code_pre_commit "$files"
        ;;
      3)
        read -p "📝 Décris la tâche : " task_desc
        local suggestion=$(suggest_branch_name "$task_desc")
        echo -e "${GREEN}🌿 Suggestion : ${NC}$suggestion"
        ;;
      4)
        echo -e "${CYAN}💡 Feature en développement...${NC}"
        ;;
      5)
        configure_ai_settings
        ;;
      6)
        break
        ;;
      *)
        echo -e "${RED}❌ Choix invalide${NC}"
        ;;
    esac
    echo
  done
}

# --- Configure AI settings ---
configure_ai_settings() {
  echo -e "\n${CYAN}🔧 Configuration AI${NC}"
  echo -e "Provider actuel : ${YELLOW}${AI_PROVIDER:-non configuré}${NC}"
  
  PS3=$'\n👉 Choisir un provider AI : '
  select provider in "OpenAI (GPT-4)" "Anthropic (Claude)" "Google (Gemini)" "Local (Ollama)" "Annuler"; do
    case $REPLY in
      1)
        read -p "🔑 OpenAI API Key : " api_key
        if [[ -n "$api_key" ]]; then
          echo "export OPENAI_API_KEY='$api_key'" >> ~/.bashrc
          echo "export AI_PROVIDER='openai'" >> ~/.bashrc
          echo -e "${GREEN}✅ OpenAI configuré !${NC}"
        fi
        break
        ;;
      2)
        read -p "🔑 Anthropic API Key : " api_key
        if [[ -n "$api_key" ]]; then
          echo "export ANTHROPIC_API_KEY='$api_key'" >> ~/.bashrc
          echo "export AI_PROVIDER='anthropic'" >> ~/.bashrc
          echo -e "${GREEN}✅ Anthropic configuré !${NC}"
        fi
        break
        ;;
      3)
        read -p "🔑 Google API Key : " api_key
        if [[ -n "$api_key" ]]; then
          echo "export GOOGLE_API_KEY='$api_key'" >> ~/.bashrc
          echo "export AI_PROVIDER='google'" >> ~/.bashrc
          echo -e "${GREEN}✅ Google configuré !${NC}"
        fi
        break
        ;;
      4)
        echo -e "${CYAN}📥 Installation Ollama : https://ollama.ai${NC}"
        echo "export AI_PROVIDER='local'" >> ~/.bashrc
        echo -e "${GREEN}✅ Mode local configuré !${NC}"
        break
        ;;
      5)
        break
        ;;
    esac
  done
}

# Export functions
export -f check_ai_available
export -f generate_commit_message
export -f analyze_code_pre_commit
export -f suggest_branch_name
export -f ai_interactive_mode
export -f configure_ai_settings