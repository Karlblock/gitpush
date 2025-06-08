#!/bin/bash

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

echo -e "\033[1;36m🔧 Gitpush - Assistant Git interactif\033[0m"


# Branche actuelle
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo -e "\n📍 Branche actuelle : \033[1;35m$current_branch\033[0m"

if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
  echo -e "\033[1;31m🛑 Tu es sur une branche critique : $current_branch\033[0m"
  read -p "❗ Continuer quand même ? (y/N) : " confirm_main
  [[ "$confirm_main" =~ ^[yY]$ ]] || { echo -e "\033[1;31m✘ Opération annulée.\033[0m"; exit 1; }
fi

# Message de commit
read -p "✏️ Message de commit : " msg
[ -z "$msg" ] && { echo -e "\033[1;31m✘ Message requis.\033[0m"; exit 1; }

# Pull --rebase
read -p "🔄 Faire un pull --rebase avant ? (y/N) : " do_sync

# Tag
read -p "🏷️  Créer un tag ? (y/N) : " do_tag
if [[ "$do_tag" =~ ^[yY]$ ]]; then
  read -p "➕ Utiliser un tag personnalisé (ex: v1.2.0) ou laisser en auto ? [auto|vX.Y.Z] : " custom_tag
fi

# Release GitHub
read -p "🚀 Créer une GitHub Release ? (y/N) : " do_release

echo -e "\n📦 Résumé de l'action :"
echo -e "• 📝 Commit : \033[1;32m$msg\033[0m"
[[ "$do_sync" =~ ^[yY]$ ]] && echo -e "• 🔄 Pull : \033[1;36mactivé\033[0m" || echo -e "• 🔄 Pull : désactivé"
[[ "$do_tag" =~ ^[yY]$ ]] && echo -e "• 🏷️  Tag : \033[1;33m${custom_tag:-auto}\033[0m" || echo -e "• 🏷️  Tag : non"
[[ "$do_release" =~ ^[yY]$ ]] && echo -e "• 🚀 Release : \033[1;36moui\033[0m" || echo -e "• 🚀 Release : non"

read -p $'\n✅ Confirmer et lancer ? (y/N) : ' confirm_run
[[ "$confirm_run" =~ ^[yY]$ ]] || { echo -e "\033[1;31m✘ Annulé.\033[0m"; exit 1; }

# Git actions
git add .
git commit -m "$msg"

[[ "$do_sync" =~ ^[yY]$ ]] && git pull --rebase
git push

# Tagging
if [[ "$do_tag" =~ ^[yY]$ ]]; then
  if [[ "$custom_tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
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
  git tag "$new_tag"
  git push origin "$new_tag"

  # Mise à jour CHANGELOG
  echo -e "## $new_tag - $(date +%F)\n- $msg\n" | cat - CHANGELOG.md 2>/dev/null > temp && mv temp CHANGELOG.md
  git add CHANGELOG.md
  git commit -m "docs: update CHANGELOG for $new_tag"
  git push
fi

# GitHub Release
if [[ "$do_release" =~ ^[yY]$ ]]; then
  if command -v gh &> /dev/null; then
    gh release create "$new_tag" --title "$new_tag" --notes-from=diff
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

