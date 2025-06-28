#!/bin/bash

GITPUSH_VERSION="v0.4.0-dev"
SIMULATE=false
AUTO_CONFIRM=false
MSG=""
DO_SYNC="N"
DO_TAG="N"
CUSTOM_TAG=""
DO_RELEASE="N"
NEW_TAG="" # To store the generated or custom tag
DO_ISSUES="N"
ISSUE_TITLE=""
ISSUE_BODY=""
ISSUE_LABELS=""
CLOSE_ISSUE=""

# --- Colors and styles ---
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
NC="\033[0m" # No Color

# --- Default labels for issues ---
DEFAULT_LABELS=("bug" "enhancement" "feature" "documentation" "question" "help wanted" "good first issue")

# --- Helper function to run commands with simulation and error handling ---
run_command() {
  local error_msg="${!#}" # Last argument is the error message
  local cmd_args=("${@:1:$#-1}") # All arguments except the last one are command and its args

  if $SIMULATE; then
    echo -e "${CYAN}Simulate:${NC} ${cmd_args[*]}"
  else
    echo -e "${CYAN}Executing:${NC} ${cmd_args[*]}"
    "${cmd_args[@]}"
    if [ $? -ne 0 ]; then
      echo -e "${RED}Error:${NC} $error_msg"
      exit 1
    fi
  fi
}

# --- Display banner ---
display_banner() {
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
  echo -e "${CYAN}🔧 Gitpush - Assistant Git interactif ${MAGENTA}$GITPUSH_VERSION${NC}"
}

# --- Parse command line arguments ---
parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --version|-v)
        echo "gitpush $GITPUSH_VERSION"
        exit 0
        ;;
      --help)
        echo -e "Usage: gitpush [options]\n"
        echo "Options:"
        echo "  --version      Affiche la version"
        echo "  --help         Affiche cette aide"
        echo "  --simulate     Affiche les actions sans les exécuter"
        echo "  --yes          Exécute toutes les actions sans confirmation"
        echo "  --message|-m   Message de commit (pour mode non-interactif)"
        echo "  --issues       Gestion des issues GitHub"
        shift
        exit 0
        ;;
      --simulate)
        SIMULATE=true
        shift
        ;;
      --yes)
        AUTO_CONFIRM=true
        shift
        ;;
      --message|-m)
        if [[ -n "$2" && "$2" != --* ]]; then
          MSG="$2"
          shift 2 # Consume the argument and its value
        else
          echo -e "${RED}Error:${NC} --message requires a value."
          exit 1
        fi
        ;;
      --issues)
        issues_management
        exit 0
        ;;
      *)
        # Unknown argument, ignore for now or add error handling
        shift
        ;;
    esac
  done
}

# --- Get Git context (branch and repo name) ---
get_git_context() {
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -z "$current_branch" ]; then
    echo -e "${RED}Error:${NC} Pas un dépôt Git. Quitting."
    exit 1
  fi
  repo_name=$(basename -s .git "$(git config --get remote.origin.url 2>/dev/null)")

  echo -e "\n📍 Branche actuelle : ${MAGENTA}$current_branch${NC}"
  echo -e "📦 Dépôt : ${CYAN}${repo_name:-Dépôt inconnu}${NC}"
}

# --- Check if GitHub CLI is available ---
check_gh_cli() {
  if ! command -v gh &> /dev/null; then
    echo -e "${RED}⚠️ GitHub CLI (gh) n'est pas installé.${NC}"
    echo -e "${YELLOW}📥 Installation : https://cli.github.com/${NC}"
    return 1
  fi
  return 0
}

# --- List open issues ---
list_open_issues() {
  if ! check_gh_cli; then return 1; fi
  
  echo -e "\n${CYAN}📋 Issues ouvertes :${NC}"
  gh issue list --limit 10 --state open --json number,title,labels --template '
  {{- range . -}}
  {{- printf "#%v" .number -}} {{ .title }}
  {{- if .labels -}} [{{- range $i, $label := .labels -}}{{- if $i -}}, {{- end -}}{{ $label.name }}{{- end -}}]{{- end }}
  {{ end }}'
}

# --- Create a new issue ---
create_issue() {
  if ! check_gh_cli; then return 1; fi
  
  echo -e "\n${GREEN}➕ Création d'une nouvelle issue${NC}"
  
  read -p "📝 Titre de l'issue : " ISSUE_TITLE
  [ -z "$ISSUE_TITLE" ] && { echo -e "${RED}✘ Titre requis.${NC}"; return 1; }
  
  read -p "📄 Description (optionnel) : " ISSUE_BODY
  
  echo -e "\n🏷️ Labels disponibles :"
  for i in "${!DEFAULT_LABELS[@]}"; do
    echo -e "  ${YELLOW}$((i+1)).${NC} ${DEFAULT_LABELS[i]}"
  done
  
  read -p "🔖 Numéros des labels (ex: 1,3,5) ou personnalisés (ex: urgent,backend) : " label_input
  
  local labels_cmd=""
  if [[ -n "$label_input" ]]; then
    if [[ "$label_input" =~ ^[0-9,]+$ ]]; then
      # Numbered selection
      IFS=',' read -ra ADDR <<< "$label_input"
      for i in "${ADDR[@]}"; do
        if [[ $i -ge 1 && $i -le ${#DEFAULT_LABELS[@]} ]]; then
          labels_cmd+="--label \"${DEFAULT_LABELS[$((i-1))]}\" "
        fi
      done
    else
      # Custom labels
      IFS=',' read -ra ADDR <<< "$label_input"
      for label in "${ADDR[@]}"; do
        labels_cmd+="--label \"${label// /}\" "
      done
    fi
  fi
  
  local cmd="gh issue create --title \"$ISSUE_TITLE\""
  [[ -n "$ISSUE_BODY" ]] && cmd+=" --body \"$ISSUE_BODY\""
  [[ -n "$labels_cmd" ]] && cmd+=" $labels_cmd"
  
  if $SIMULATE; then
    echo -e "${CYAN}Simulate:${NC} $cmd"
  else
    eval "$cmd"
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}✅ Issue créée avec succès !${NC}"
    else
      echo -e "${RED}❌ Erreur lors de la création de l'issue.${NC}"
    fi
  fi
}

# --- Close an issue ---
close_issue() {
  if ! check_gh_cli; then return 1; fi
  
  list_open_issues
  echo
  read -p "🔒 Numéro de l'issue à fermer (ex: 42) : " issue_number
  
  if [[ "$issue_number" =~ ^[0-9]+$ ]]; then
    read -p "💬 Commentaire de fermeture (optionnel) : " close_comment
    
    local cmd="gh issue close $issue_number"
    [[ -n "$close_comment" ]] && cmd+=" --comment \"$close_comment\""
    
    if $SIMULATE; then
      echo -e "${CYAN}Simulate:${NC} $cmd"
    else
      eval "$cmd"
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Issue #$issue_number fermée !${NC}"
      else
        echo -e "${RED}❌ Erreur lors de la fermeture.${NC}"
      fi
    fi
  else
    echo -e "${RED}❌ Numéro d'issue invalide.${NC}"
  fi
}

# --- Manage labels ---
manage_labels() {
  if ! check_gh_cli; then return 1; fi
  
  echo -e "\n${MAGENTA}🏷️ Gestion des Labels${NC}"
  PS3=$'\n👉 Ton choix : '
  options=("📋 Lister les labels" "➕ Créer un label" "🗑️ Supprimer un label" "🔙 Retour")
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        echo -e "\n${CYAN}📋 Labels existants :${NC}"
        gh label list
        ;;
      2)
        read -p "📝 Nom du label : " label_name
        read -p "📄 Description : " label_desc
        read -p "🎨 Couleur (hex sans #, ex: ff0000) : " label_color
        
        if [[ -n "$label_name" ]]; then
          local cmd="gh label create \"$label_name\""
          [[ -n "$label_desc" ]] && cmd+=" --description \"$label_desc\""
          [[ -n "$label_color" ]] && cmd+=" --color \"$label_color\""
          
          if $SIMULATE; then
            echo -e "${CYAN}Simulate:${NC} $cmd"
          else
            eval "$cmd"
          fi
        fi
        ;;
      3)
        gh label list
        read -p "🗑️ Nom du label à supprimer : " label_to_delete
        if [[ -n "$label_to_delete" ]]; then
          if $SIMULATE; then
            echo -e "${CYAN}Simulate:${NC} gh label delete \"$label_to_delete\""
          else
            gh label delete "$label_to_delete" --confirm
          fi
        fi
        ;;
      4)
        break
        ;;
      *)
        echo -e "${RED}❌ Choix invalide.${NC}"
        ;;
    esac
  done
}

# --- Auto-detect issue keywords in commit message ---
detect_issue_keywords() {
  local msg="$1"
  local keywords=("fix" "fixes" "fixed" "close" "closes" "closed" "resolve" "resolves" "resolved")
  
  for keyword in "${keywords[@]}"; do
    if [[ "$msg" =~ $keyword[[:space:]]+#([0-9]+) ]]; then
      local issue_num="${BASH_REMATCH[1]}"
      echo -e "${YELLOW}🔗 Détection automatique : ce commit pourrait fermer l'issue #$issue_num${NC}"
      if ! $AUTO_CONFIRM; then
        read -p "❓ Confirmer la fermeture de l'issue #$issue_num ? (y/N) : " confirm_close
        if [[ "$confirm_close" =~ ^[yY]$ ]]; then
          CLOSE_ISSUE="$issue_num"
        fi
      else
        CLOSE_ISSUE="$issue_num"
      fi
      break
    fi
  done
}

# --- Auto-suggest creating issue based on commit ---
suggest_issue_creation() {
  local msg="$1"
  local bug_keywords=("bug" "error" "crash" "broken" "issue" "problem")
  local feature_keywords=("feature" "add" "implement" "create" "new")
  local todo_keywords=("todo" "fixme" "hack" "temporary")
  
  for keyword in "${bug_keywords[@]}"; do
    if [[ "$msg" =~ $keyword ]]; then
      echo -e "${YELLOW}🐛 Ce commit semble corriger un bug.${NC}"
      if ! $AUTO_CONFIRM; then
        read -p "❓ Créer une issue de suivi ? (y/N) : " create_bug_issue
        if [[ "$create_bug_issue" =~ ^[yY]$ ]]; then
          quick_issue_creation "bug" "$msg"
        fi
      fi
      return
    fi
  done
  
  for keyword in "${feature_keywords[@]}"; do
    if [[ "$msg" =~ $keyword ]]; then
      echo -e "${BLUE}✨ Ce commit semble ajouter une fonctionnalité.${NC}"
      if ! $AUTO_CONFIRM; then
        read -p "❓ Créer une issue pour documenter cette feature ? (y/N) : " create_feature_issue
        if [[ "$create_feature_issue" =~ ^[yY]$ ]]; then
          quick_issue_creation "enhancement" "$msg"
        fi
      fi
      return
    fi
  done
}

# --- Quick issue creation ---
quick_issue_creation() {
  local suggested_label="$1"
  local commit_msg="$2"
  
  echo -e "\n${GREEN}⚡ Création rapide d'issue${NC}"
  ISSUE_TITLE="Issue: $commit_msg"
  read -p "📝 Titre (Entrée pour garder '$ISSUE_TITLE') : " user_title
  [[ -n "$user_title" ]] && ISSUE_TITLE="$user_title"
  read -p "📄 Description courte : " ISSUE_BODY
  
  local cmd="gh issue create --title \"$ISSUE_TITLE\" --label \"$suggested_label\""
  [[ -n "$ISSUE_BODY" ]] && cmd+=" --body \"$ISSUE_BODY\""
  
  if $SIMULATE; then
    echo -e "${CYAN}Simulate:${NC} $cmd"
  else
    eval "$cmd"
  fi
}

# --- Main issues management menu ---
issues_management() {
  if ! check_gh_cli; then return 1; fi
  
  display_banner
  echo -e "\n${MAGENTA}🎯 Gestion des Issues GitHub${NC}"
  
  PS3=$'\n👉 Ton choix : '
  options=("📋 Lister les issues ouvertes" "➕ Créer une nouvelle issue" "🔒 Fermer une issue" "🏷️ Gestion des labels" "🔙 Retour au menu principal")
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        list_open_issues
        ;;
      2)
        create_issue
        ;;
      3)
        close_issue
        ;;
      4)
        manage_labels
        ;;
      5)
        break
        ;;
      *)
        echo -e "${RED}❌ Choix invalide.${NC}"
        ;;
    esac
    echo
  done
}

# --- Handle critical branches (main/master) ---
handle_critical_branch() {
  if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    echo -e "${RED}🚩 Tu es sur une branche critique : $current_branch${NC}"
    if ! $AUTO_CONFIRM; then
      read -p "❗ Continuer quand même ? (y/N) : " confirm_main
      if [[ ! "$confirm_main" =~ ^[yY]$ ]]; then
        echo -e "${RED}✘ Opération annulée.${NC}"
        echo -e "\n🔁 Que veux-tu faire maintenant ?"
        PS3=$'\n👉 Ton choix : '
        options=("🔀 Changer de branche existante" "➕ Créer une nouvelle branche" "❌ Quitter")

        select opt in "${options[@]}"; do
          case $REPLY in
            1)
              echo -e "\n📂 Branches locales :"
              branches=$(git branch --format="%(refname:short)" | grep -vE "^(main|master)$")
              select branch in $branches "Retour"; do
                if [[ "$branch" == "Retour" ]]; then
                  break
                elif [[ -n "$branch" ]]; then
                  run_command git switch "$branch" "Impossible de changer de branche."
                  current_branch="$branch"
                  echo -e "${GREEN}✔ Switched to branch: $branch${NC}"
                  break 2
                else
                  echo -e "${RED}❌ Choix invalide.${NC}"
                fi
              done
              ;;
            2)
              read -p "🌟 Nom de la nouvelle branche : " new_branch
              if [[ -n "$new_branch" ]]; then
                run_command git checkout -b "$new_branch" "Impossible de créer la nouvelle branche."
                current_branch="$new_branch"
                echo -e "${GREEN}✔ Nouvelle branche créée et sélectionnée : $new_branch${NC}"
                break
              else
                echo -e "${YELLOW}⚠️ Nom invalide.${NC}"
              fi
              ;;
            3)
              echo -e "${YELLOW}👋 À bientôt !${NC}"
              exit 0
              ;;
            *)
              echo -e "${RED}❌ Choix invalide.${NC}"
              ;;
          esac
        done
      fi
    fi
  fi
}

# --- Get user inputs for commit, pull, tag, release ---
get_user_inputs() {
  if [ -z "$MSG" ]; then
    read -p "✏️ Message de commit : " MSG
    [ -z "$MSG" ] && { echo -e "${RED}✘ Message requis.${NC}"; exit 1; }
  fi
  
  # Auto-detect and handle issue keywords
  detect_issue_keywords "$MSG"
  suggest_issue_creation "$MSG"

  if ! $AUTO_CONFIRM; then
    read -p "🔄 Faire un pull --rebase avant ? (y/N) : " DO_SYNC
    read -p "🏷️  Créer un tag ? (y/N) : " DO_TAG
    if [[ "$DO_TAG" =~ ^[yY]$ ]]; then
      read -p "➕ Utiliser un tag personnalisé (ex: v1.2.0) ou laisser en auto ? [auto|vX.Y.Z] : " CUSTOM_TAG
    fi
    read -p "🚀 Créer une GitHub Release ? (y/N) : " DO_RELEASE
    
    # Ask about issues management
    if check_gh_cli &>/dev/null; then
      read -p "🎯 Accéder au menu Issues ? (y/N) : " DO_ISSUES
      if [[ "$DO_ISSUES" =~ ^[yY]$ ]]; then
        issues_management
      fi
    fi
  else
    # Default values for auto-confirm mode
    DO_SYNC="Y"
    DO_TAG="Y"
    CUSTOM_TAG="auto"
    DO_RELEASE="Y"
  fi
}

# --- Summarize and confirm actions ---
summarize_and_confirm() {
  echo -e "\n📦 Résumé de l'action :"
  echo -e "• 📝 Commit : ${GREEN}$MSG${NC}"
  [[ "$DO_SYNC" =~ ^[yY]$ ]] && echo -e "• 🔄 Pull : ${CYAN}activé${NC}" || echo -e "• 🔄 Pull : désactivé"
  [[ "$DO_TAG" =~ ^[yY]$ ]] && echo -e "• 🏷️  Tag : ${YELLOW}${CUSTOM_TAG:-auto}${NC}" || echo -e "• 🏷️  Tag : non"
  [[ "$DO_RELEASE" =~ ^[yY]$ ]] && echo -e "• 🚀 Release : ${CYAN}oui${NC}" || echo -e "• 🚀 Release : non"
  [[ -n "$CLOSE_ISSUE" ]] && echo -e "• 🔒 Fermer issue : ${YELLOW}#$CLOSE_ISSUE${NC}"

  if ! $AUTO_CONFIRM; then
    read -p $'\n✅ Confirmer et lancer ? (y/N) : ' confirm_run
    [[ "$confirm_run" =~ ^[yY]$ ]] || { echo -e "${RED}✘ Annulé.${NC}"; exit 1; }
  fi
}

# --- Perform Git actions (add, commit, pull, push) ---
perform_git_actions() {
  run_command git add . "Impossible d'ajouter les fichiers."
  run_command git commit -m "$MSG" "Impossible de créer le commit."
  [[ "$DO_SYNC" =~ ^[yY]$ ]] && run_command git pull --rebase "Impossible de pull --rebase."
  run_command git push "Impossible de push."
  
  # Close issue if detected
  if [[ -n "$CLOSE_ISSUE" ]] && check_gh_cli &>/dev/null; then
    if $SIMULATE; then
      echo -e "${CYAN}Simulate:${NC} gh issue close $CLOSE_ISSUE --comment 'Fixed by commit: $MSG'"
    else
      gh issue close "$CLOSE_ISSUE" --comment "Fixed by commit: $MSG"
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Issue #$CLOSE_ISSUE fermée automatiquement !${NC}"
      fi
    fi
  fi
}

# --- Handle tagging ---
handle_tagging() {
  if [[ "$DO_TAG" =~ ^[yY]$ ]]; then
    if [[ "$CUSTOM_TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
      NEW_TAG="$CUSTOM_TAG"
    else
      last_tag=$(git tag --sort=-v:refname | head -n 1)
      if [[ $last_tag =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
        major=${BASH_REMATCH[1]}
        minor=${BASH_REMATCH[2]}
        patch=$((BASH_REMATCH[3] + 1))
        NEW_TAG="v$major.$minor.$patch"
      else
        NEW_TAG="v0.0.1"
      fi
    fi

    if git tag | grep -q "^$NEW_TAG$"; then
      echo -e "${RED}⚠️ Le tag $NEW_TAG existe déjà. Aucun tag ajouté.${NC}"
    else
      run_command git tag "$NEW_TAG" "Impossible de créer le tag."
      run_command git push origin "$NEW_TAG" "Impossible de pousser le tag."
      echo -e "${GREEN}✅ Tag $NEW_TAG ajouté et poussé.${NC}"

      # Update CHANGELOG
      if ! grep -q "^## $NEW_TAG" CHANGELOG.md 2>/dev/null; then
        echo -e "## $NEW_TAG - $(date +%F)\n- $MSG\n" | cat - CHANGELOG.md 2>/dev/null > temp && mv temp CHANGELOG.md
        run_command git add CHANGELOG.md "Impossible d'ajouter CHANGELOG.md."
        run_command git commit -m "docs: update CHANGELOG for $NEW_TAG" "Impossible de commiter le CHANGELOG."
        run_command git push "Impossible de pousser le CHANGELOG."
      else
        echo -e "${YELLOW}ℹ️ Le changelog contient déjà une entrée pour $NEW_TAG. Ignoré.${NC}"
      fi
    fi
  fi
}

# --- Create GitHub Release ---
create_github_release() {
  if [[ "$DO_RELEASE" =~ ^[yY]$ ]]; then
    if command -v gh &> /dev/null; then
      if [[ -n "$NEW_TAG" ]] && git tag | grep -q "^$NEW_TAG$"; then
        run_command gh release create "$NEW_TAG" --title "$NEW_TAG" --generate-notes "Impossible de créer la GitHub Release."
      else
        echo -e "${YELLOW}⚠️ Aucune release créée car le tag est manquant ou existait déjà.${NC}"
      fi
    else
      echo -e "${RED}⚠️ GitHub CLI non installé, release ignorée.${NC}"
    fi
  fi
}

# --- Open GitHub page ---
open_github_page() {
  remote_url=$(git config --get remote.origin.url)
  if [[ $remote_url == git@github.com:* ]]; then
    web_url="https://github.com/${remote_url#git@github.com:}"
    web_url="${web_url%.git}"
  elif [[ $remote_url == https://github.com/* ]]; then
    web_url="${remote_url%.git}"
  fi

  [[ -n "$web_url" ]] && xdg-open "$web_url" > /dev/null 2>&1 &
}

# --- Main execution flow ---
main() {
  parse_args "$@"
  display_banner
  get_git_context

  if $SIMULATE; then
    echo -e "\n${CYAN}🔢 Mode simulation activé : aucune commande ne sera exécutée.${NC}"
  fi

  # Show main menu if no message provided and not auto-confirm
  if [[ -z "$MSG" ]] && ! $AUTO_CONFIRM; then
    echo -e "\n${MAGENTA}🎯 Menu Principal${NC}"
    PS3=$'\n👉 Ton choix : '
    options=("🚀 Workflow Git complet" "📋 Gestion des Issues" "❌ Quitter")
    
    select opt in "${options[@]}"; do
      case $REPLY in
        1)
          break
          ;;
        2)
          issues_management
          exit 0
          ;;
        3)
          echo -e "${YELLOW}👋 À bientôt !${NC}"
          exit 0
          ;;
        *)
          echo -e "${RED}❌ Choix invalide.${NC}"
          ;;
      esac
    done
  fi

  handle_critical_branch
  get_user_inputs
  summarize_and_confirm
  perform_git_actions
  handle_tagging
  create_github_release
  open_github_page
}

main "$@"