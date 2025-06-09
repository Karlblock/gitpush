#!/bin/bash

GITPUSH_VERSION="v0.3.1-dev"
SIMULATE=false
AUTO_CONFIRM=false

# ─── Lecture des flags ─────────────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
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
      exit 0
      ;;
    --simulate)
      SIMULATE=true
      ;;
    --yes)
      AUTO_CONFIRM=true
      ;;
  esac
  shift
done

clear

# ─── Affichage bannière ─────────────────────────────────────────────────────
cat << "EOF"
          _ __                   __  
   ____ _(_) /_____  __  _______/ /_ 
  / __ `/ / __/ __ \/ / / / ___/ __ \
 / /_/ / / /_/ /_/ / /_/ (__  ) / / / 
 \__, /_/\__/ .___/\__,_/____/_/ /_/  
/____/     /_/                        

        🚀 gitpush — by Karl Block
EOF

echo -e "\033[1;36m🔧 Gitpush - Assistant Git interactif \033[1;35m$GITPUSH_VERSION\033[0m"

# ─── Contexte Git : branche & dépôt ────────────────────────────────────────
current_branch=$(git rev-parse --abbrev-ref HEAD)
repo_name=$(basename -s .git "$(git config --get remote.origin.url 2>/dev/null)")

echo -e "\n📍 Branche actuelle : \033[1;35m$current_branch\033[0m"
echo -e "📦 Dépôt : \033[1;36m${repo_name:-Dépôt inconnu}\033[0m"

# ─── Alerte si branche critique ────────────────────────────────────────────
if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
  echo -e "\033[1;31m🚩 Tu es sur une branche critique : $current_branch\033[0m"
  if ! $AUTO_CONFIRM; then
    read -p "❗ Continuer quand même ? (y/N) : " confirm_main
    if [[ ! "$confirm_main" =~ ^[yY]$ ]]; then
      echo -e "\033[1;31m✘ Opération annulée.\033[0m"
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
                git switch "$branch"
                current_branch="$branch"
                echo -e "\033[1;32m✔ Switched to branch: $branch\033[0m"
                break 2
              else
                echo "❌ Choix invalide."
              fi
            done
            ;;
          2)
            read -p "🌟 Nom de la nouvelle branche : " new_branch
            if [[ -n "$new_branch" ]]; then
              git checkout -b "$new_branch"
              current_branch="$new_branch"
              echo -e "\033[1;32m✔ Nouvelle branche créée et sélectionnée : $new_branch\033[0m"
              break
            else
              echo "⚠️ Nom invalide."
            fi
            ;;
          3)
            echo -e "\033[1;33m👋 À bientôt !\033[0m"
            exit 0
            ;;
          *)
            echo "❌ Choix invalide."
            ;;
        esac
      done
    fi
  fi
fi

# ─── Mode simulation ? ──────────────────────────────────────────────────────
if $SIMULATE; then
  echo -e "\n🔢 Mode simulation activé : aucune commande ne sera exécutée."
fi

# Message de commit
read -p "✏️ Message de commit : " msg
[ -z "$msg" ] && { echo -e "\033[1;31m✘ Message requis.\033[0m"; exit 1; }

read -p "🔄 Faire un pull --rebase avant ? (y/N) : " do_sync
read -p "🏷️  Créer un tag ? (y/N) : " do_tag
if [[ "$do_tag" =~ ^[yY]$ ]]; then
  read -p "➕ Utiliser un tag personnalisé (ex: v1.2.0) ou laisser en auto ? [auto|vX.Y.Z] : " custom_tag
fi
read -p "🚀 Créer une GitHub Release ? (y/N) : " do_release

echo -e "\n📦 Résumé de l'action :"
echo -e "• 📝 Commit : \033[1;32m$msg\033[0m"
[[ "$do_sync" =~ ^[yY]$ ]] && echo -e "• 🔄 Pull : \033[1;36mactivé\033[0m" || echo -e "• 🔄 Pull : désactivé"
[[ "$do_tag" =~ ^[yY]$ ]] && echo -e "• 🏷️  Tag : \033[1;33m${custom_tag:-auto}\033[0m" || echo -e "• 🏷️  Tag : non"
[[ "$do_release" =~ ^[yY]$ ]] && echo -e "• 🚀 Release : \033[1;36moui\033[0m" || echo -e "• 🚀 Release : non"

read -p $'\n✅ Confirmer et lancer ? (y/N) : ' confirm_run
[[ "$confirm_run" =~ ^[yY]$ ]] || { echo -e "\033[1;31m✘ Annulé.\033[0m"; exit 1; }

git add .
git commit -m "$msg"
[[ "$do_sync" =~ ^[yY]$ ]] && git pull --rebase
git push

# Tagging sécurisé
if [[ "$do_tag" =~ ^[yY]$ ]]; then
  if [[ "$custom_tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
    new_tag="$custom_tag"
  else
    last_tag=$(git tag --sort=-v:refname | head -n 1)
    if [[ $last_tag =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
      major=${BASH_REMATCH[1]}
      minor=${BASH_REMATCH[2]}
      patch=$((BASH_REMATCH[3] + 1))
      new_tag="v$major.$minor.$patch"
    else
      new_tag="v0.0.1"
    fi
  fi

  # Vérifie si le tag existe déjà
  if git tag | grep -q "^$new_tag$"; then
    echo -e "\033[1;31m⚠️ Le tag $new_tag existe déjà. Aucun tag ajouté.\033[0m"
  else
    git tag "$new_tag"
    git push origin "$new_tag"
    echo -e "\033[1;32m✅ Tag $new_tag ajouté et poussé.\033[0m"

    # Mise à jour du CHANGELOG
    echo -e "## $new_tag - $(date +%F)\n- $msg\n" | cat - CHANGELOG.md 2>/dev/null > temp && mv temp CHANGELOG.md
    git add CHANGELOG.md
    git commit -m "docs: update CHANGELOG for $new_tag"
    git push
  fi
fi

# GitHub Release
if [[ "$do_release" =~ ^[yY]$ ]]; then
  if command -v gh &> /dev/null; then
    if [[ -n "$new_tag" ]] && git tag | grep -q "^$new_tag$"; then
      gh release create "$new_tag" --title "$new_tag" --generate-notes
    else
      echo -e "\033[1;33m⚠️ Aucune release créée car le tag est manquant ou existait déjà.\033[0m"
    fi
  else
    echo -e "\033[1;31m⚠️ GitHub CLI non installé, release ignorée.\033[0m"
  fi
fi

# Ouvrir la page GitHub
remote_url=$(git config --get remote.origin.url)
if [[ $remote_url == git@github.com:* ]]; then
  web_url="https://github.com/${remote_url#git@github.com:}"
  web_url="${web_url%.git}"
elif [[ $remote_url == https://github.com/* ]]; then
  web_url="${remote_url%.git}"
fi

[[ -n "$web_url" ]] && xdg-open "$web_url" > /dev/null 2>&1 &
