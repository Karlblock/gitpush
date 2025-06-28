#!/bin/bash

GITPUSH_VERSION="v0.3.1-dev"
SIMULATE=false
AUTO_CONFIRM=false
MSG=""
DO_SYNC="N"
DO_TAG="N"
CUSTOM_TAG=""
DO_RELEASE="N"
NEW_TAG="" # To store the generated or custom tag

# --- Colors and styles ---
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m" # No Color

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

  if ! $AUTO_CONFIRM; then
    read -p "🔄 Faire un pull --rebase avant ? (y/N) : " DO_SYNC
    read -p "🏷️  Créer un tag ? (y/N) : " DO_TAG
    if [[ "$DO_TAG" =~ ^[yY]$ ]]; then
      read -p "➕ Utiliser un tag personnalisé (ex: v1.2.0) ou laisser en auto ? [auto|vX.Y.Z] : " CUSTOM_TAG
    fi
    read -p "🚀 Créer une GitHub Release ? (y/N) : " DO_RELEASE
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

  handle_critical_branch
  get_user_inputs
  summarize_and_confirm
  perform_git_actions
  handle_tagging
  create_github_release
  open_github_page
}

main "$@"