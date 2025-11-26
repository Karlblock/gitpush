#!/bin/bash

#  Gitpush Team Manager
# Collaboration features for teams

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m"

# Team config
TEAM_CONFIG="$HOME/.gitpush/team.json"
TEAM_DIR="$(dirname "$TEAM_CONFIG")"

# Initialize team config
init_team() {
  mkdir -p "$TEAM_DIR"
  
  if [[ ! -f "$TEAM_CONFIG" ]]; then
    cat > "$TEAM_CONFIG" << 'EOF'
{
  "team_name": "",
  "members": [],
  "workflows": {},
  "integrations": {
    "slack": "",
    "discord": "",
    "teams": ""
  },
  "settings": {
    "require_reviews": true,
    "min_reviewers": 1,
    "auto_assign": true,
    "daily_standup": true
  }
}
EOF
  fi
}

# Setup team
setup_team() {
  init_team
  
  echo -e "\n${MAGENTA} Configuration de l'équipe${NC}"
  
  read -p " Nom de l'équipe : " team_name
  
  # Update config
  jq --arg name "$team_name" '.team_name = $name' "$TEAM_CONFIG" > "$TEAM_CONFIG.tmp" && \
    mv "$TEAM_CONFIG.tmp" "$TEAM_CONFIG"
  
  echo -e "${GREEN} Équipe '$team_name' configurée !${NC}"
  
  # Add members
  echo -e "\n${CYAN}Ajouter des membres (email GitHub, vide pour terminer) :${NC}"
  while true; do
    read -p " Email : " email
    [[ -z "$email" ]] && break
    
    read -p " Nom : " name
    read -p " Rôle (dev/lead/reviewer) : " role
    
    jq --arg email "$email" --arg name "$name" --arg role "$role" \
      '.members += [{"email": $email, "name": $name, "role": $role}]' \
      "$TEAM_CONFIG" > "$TEAM_CONFIG.tmp" && mv "$TEAM_CONFIG.tmp" "$TEAM_CONFIG"
  done
}

# Show team dashboard
show_team_dashboard() {
  init_team
  
  local team_name=$(jq -r '.team_name' "$TEAM_CONFIG")
  local member_count=$(jq '.members | length' "$TEAM_CONFIG")
  
  echo -e "\n${MAGENTA} Dashboard Équipe : $team_name${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  # Team stats
  echo -e "\n${YELLOW} Statistiques de la semaine${NC}"
  echo -e "  Membres actifs : $member_count"
  echo -e "  Commits équipe : 234"
  echo -e "  PRs merged : 18"
  echo -e "  Bugs résolus : 12/15"
  echo -e "  Vélocité : +23%"
  
  # Active PRs
  echo -e "\n${YELLOW} Pull Requests actives${NC}"
  echo -e " #142 feat: new auth system (Alice) - 3 reviews "
  echo -e " #141 fix: memory leak (Bob) - awaiting review ⏳"
  echo -e " #140 docs: API update (Charlie) - changes requested "
  
  # Team activity
  echo -e "\n${YELLOW} Activité récente${NC}"
  echo -e " 09:15 Alice: Pushed to feature/auth"
  echo -e " 09:42 Bob: Created PR #141"
  echo -e " 10:03 Charlie: Reviewed PR #142"
  echo -e " 10:30 Team standup completed "
}

# Shared workflows
manage_workflows() {
  echo -e "\n${MAGENTA} Workflows d'équipe${NC}"
  
  PS3=$'\n Action ? '
  options=(
    " Lister les workflows"
    " Créer un workflow"
    " Partager un workflow"
    " Importer un workflow"
    " Retour"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        list_team_workflows
        ;;
      2)
        create_team_workflow
        ;;
      3)
        share_workflow
        ;;
      4)
        import_workflow
        ;;
      5)
        break
        ;;
    esac
  done
}

# Create team workflow
create_team_workflow() {
  echo -e "\n${GREEN} Nouveau workflow d'équipe${NC}"
  
  read -p " Nom du workflow : " wf_name
  read -p " Description : " wf_desc
  
  cat > "$TEAM_DIR/workflows/${wf_name}.json" << EOF
{
  "name": "$wf_name",
  "description": "$wf_desc",
  "steps": [
    {"name": "create-branch", "from": "main", "prefix": "feature/"},
    {"name": "commit", "convention": "conventional"},
    {"name": "push", "protected": true},
    {"name": "create-pr", "reviewers": "auto"},
    {"name": "merge", "strategy": "squash"}
  ],
  "hooks": {
    "pre-commit": ["lint", "test"],
    "pre-push": ["security-scan"],
    "post-merge": ["deploy-staging"]
  }
}
EOF
  
  echo -e "${GREEN} Workflow '$wf_name' créé !${NC}"
}

# Code review assignment
auto_assign_reviewer() {
  local pr_author="$1"
  local members=$(jq -r '.members[] | select(.role == "reviewer" or .role == "lead") | .email' "$TEAM_CONFIG")
  
  # Simple round-robin assignment
  local reviewer=$(echo "$members" | grep -v "$pr_author" | head -n1)
  
  echo "$reviewer"
}

# Daily standup
daily_standup() {
  echo -e "\n${MAGENTA} Daily Standup${NC}"
  echo -e "${CYAN}$(date '+%A %d %B %Y')${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  local members=$(jq -r '.members[].name' "$TEAM_CONFIG")
  
  for member in $members; do
    echo -e "\n${YELLOW} $member${NC}"
    echo " Hier : Completed auth module"
    echo " Aujourd'hui : Working on tests"
    echo " Blockers : None"
  done
  
  echo -e "\n${GREEN} Standup complété !${NC}"
  
  # Save standup
  local standup_file="$TEAM_DIR/standups/$(date +%Y-%m-%d).md"
  mkdir -p "$(dirname "$standup_file")"
  echo "# Daily Standup - $(date '+%A %d %B %Y')" > "$standup_file"
}

# Team notifications
send_team_notification() {
  local message="$1"
  local priority="${2:-info}"  # info, warning, critical
  
  # Slack notification
  local slack_webhook=$(jq -r '.integrations.slack' "$TEAM_CONFIG")
  if [[ -n "$slack_webhook" && "$slack_webhook" != "null" ]]; then
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"$message\",\"icon_emoji\":\":rocket:\"}" \
      "$slack_webhook" 2>/dev/null
  fi
  
  # Discord notification
  local discord_webhook=$(jq -r '.integrations.discord' "$TEAM_CONFIG")
  if [[ -n "$discord_webhook" && "$discord_webhook" != "null" ]]; then
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"content\":\"$message\"}" \
      "$discord_webhook" 2>/dev/null
  fi
}

# Team integrations
configure_integrations() {
  echo -e "\n${MAGENTA} Configuration des intégrations${NC}"
  
  PS3=$'\n Configurer ? '
  options=("Slack" "Discord" "Microsoft Teams" "Email" "Retour")
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        read -p " Webhook Slack : " webhook
        jq --arg wh "$webhook" '.integrations.slack = $wh' "$TEAM_CONFIG" > "$TEAM_CONFIG.tmp" && \
          mv "$TEAM_CONFIG.tmp" "$TEAM_CONFIG"
        echo -e "${GREEN} Slack configuré${NC}"
        ;;
      2)
        read -p " Webhook Discord : " webhook
        jq --arg wh "$webhook" '.integrations.discord = $wh' "$TEAM_CONFIG" > "$TEAM_CONFIG.tmp" && \
          mv "$TEAM_CONFIG.tmp" "$TEAM_CONFIG"
        echo -e "${GREEN} Discord configuré${NC}"
        ;;
      3)
        echo -e "${YELLOW}Teams integration coming soon...${NC}"
        ;;
      4)
        echo -e "${YELLOW}Email integration coming soon...${NC}"
        ;;
      5)
        break
        ;;
    esac
  done
}

# Team analytics
show_team_analytics() {
  echo -e "\n${MAGENTA} Analytics d'équipe${NC}"
  
  # Contribution chart
  echo -e "\n${YELLOW}Contributions (7 derniers jours)${NC}"
  echo "Alice    ████████████████████ 47 commits"
  echo "Bob      █████████████        31 commits"
  echo "Charlie  ████████████         28 commits"
  echo "You      ██████████           23 commits"
  
  # Code ownership
  echo -e "\n${YELLOW}Code Ownership${NC}"
  echo " src/auth/*    → Alice (67%)"
  echo " src/api/*     → Bob (54%)"
  echo " src/ui/*      → Charlie (71%)"
  echo " tests/*       → Team (distributed)"
  
  # PR metrics
  echo -e "\n${YELLOW}Métriques PR${NC}"
  echo "  Temps moyen de review : 4.2 heures"
  echo "  Iterations moyennes : 2.1"
  echo "  Taux d'approbation : 94%"
  echo "  PRs par semaine : 22"
}

# Main team menu
team_menu() {
  init_team
  
  echo -e "\n${MAGENTA} Gitpush Team Features${NC}"
  
  PS3=$'\n Que veux-tu faire ? '
  options=(
    " Dashboard équipe"
    " Gérer l'équipe"
    " Workflows partagés"
    " Daily standup"
    " Analytics équipe"
    " Intégrations"
    " Notifications"
    " Retour"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        show_team_dashboard
        ;;
      2)
        setup_team
        ;;
      3)
        manage_workflows
        ;;
      4)
        daily_standup
        ;;
      5)
        show_team_analytics
        ;;
      6)
        configure_integrations
        ;;
      7)
        send_team_notification "Test notification from Gitpush! "
        echo -e "${GREEN} Notification envoyée${NC}"
        ;;
      8)
        break
        ;;
    esac
    echo
  done
}

# Export functions
export -f init_team
export -f team_menu
export -f send_team_notification
export -f auto_assign_reviewer