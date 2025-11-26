#!/bin/bash

# Gitpush Analytics Manager
# Track and display user statistics

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m"

# Stats file location
# FIXME: should use XDG_DATA_HOME instead of hardcoded path
STATS_FILE="$HOME/.gitpush/stats.json"
STATS_DIR="$(dirname "$STATS_FILE")"

# Initialize stats file if not exists
init_stats() {
  if [[ ! -d "$STATS_DIR" ]]; then
    mkdir -p "$STATS_DIR"
  fi
  
  if [[ ! -f "$STATS_FILE" ]]; then
    cat > "$STATS_FILE" << 'EOF'
{
  "total_commits": 0,
  "total_pushes": 0,
  "issues_created": 0,
  "issues_closed": 0,
  "ai_commits": 0,
  "tags_created": 0,
  "releases_created": 0,
  "daily_stats": {},
  "most_productive_hour": null,
  "favorite_branch_prefix": null,
  "last_activity": null
}
EOF
  fi
}

# Record a commit
record_commit() {
  init_stats
  
  # Use file locking to prevent corruption from concurrent access
  local lockfile="$STATS_FILE.lock"
  local timeout=10
  local elapsed=0
  
  # Wait for lock with timeout
  while [[ -f "$lockfile" ]] && [[ $elapsed -lt $timeout ]]; do
    sleep 0.1
    ((elapsed++))
  done
  
  # Create lock
  echo $$ > "$lockfile"
  
  # Ensure cleanup on exit
  trap 'rm -f "$lockfile"' EXIT INT TERM
  
  local date=$(date +%Y-%m-%d)
  local hour=$(date +%H)
  
  # Validate JSON before processing
  if ! jq empty "$STATS_FILE" 2>/dev/null; then
    echo -e "${YELLOW}Warning: Stats file corrupted, reinitializing...${NC}" >&2
    rm -f "$STATS_FILE"
    init_stats
  fi
  
  # Update total commits
  local total=$(jq -r '.total_commits' "$STATS_FILE" 2>/dev/null || echo "0")
  ((total++))
  
  # Update daily stats with atomic operation
  local temp_file="$STATS_FILE.tmp.$$"
  jq --arg date "$date" --arg hour "$hour" --arg total "$total" '
    .total_commits = ($total | tonumber) |
    .daily_stats[$date].commits = ((.daily_stats[$date].commits // 0) + 1) |
    .daily_stats[$date].hours[$hour] = ((.daily_stats[$date].hours[$hour] // 0) + 1) |
    .last_activity = now
  ' "$STATS_FILE" > "$temp_file" 2>/dev/null
  
  # Validate output before replacing
  if jq empty "$temp_file" 2>/dev/null; then
    mv "$temp_file" "$STATS_FILE"
  else
    echo -e "${RED}Error: Failed to update stats${NC}" >&2
    rm -f "$temp_file"
  fi
  
  # Remove lock
  rm -f "$lockfile"
  trap - EXIT INT TERM
}

# Record AI usage
record_ai_usage() {
  init_stats
  
  # Use same locking mechanism as record_commit
  local lockfile="$STATS_FILE.lock"
  local timeout=10
  local elapsed=0
  
  while [[ -f "$lockfile" ]] && [[ $elapsed -lt $timeout ]]; do
    sleep 0.1
    ((elapsed++))
  done
  
  echo $$ > "$lockfile"
  trap 'rm -f "$lockfile"' EXIT INT TERM
  
  # Validate JSON
  if ! jq empty "$STATS_FILE" 2>/dev/null; then
    rm -f "$lockfile"
    trap - EXIT INT TERM
    return 1
  fi
  
  local count=$(jq -r '.ai_commits' "$STATS_FILE" 2>/dev/null || echo "0")
  ((count++))
  
  local temp_file="$STATS_FILE.tmp.$$"
  jq --arg count "$count" '.ai_commits = ($count | tonumber)' "$STATS_FILE" > "$temp_file" 2>/dev/null
  
  if jq empty "$temp_file" 2>/dev/null; then
    mv "$temp_file" "$STATS_FILE"
  else
    rm -f "$temp_file"
  fi
  
  rm -f "$lockfile"
  trap - EXIT INT TERM
}

# Display personal stats
show_personal_stats() {
  init_stats
  
  echo -e "\n${MAGENTA} Tes Statistiques Git${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  local total_commits=$(jq -r '.total_commits' "$STATS_FILE")
  local total_pushes=$(jq -r '.total_pushes' "$STATS_FILE")
  local issues_created=$(jq -r '.issues_created' "$STATS_FILE")
  local issues_closed=$(jq -r '.issues_closed' "$STATS_FILE")
  local ai_commits=$(jq -r '.ai_commits' "$STATS_FILE")
  local tags_created=$(jq -r '.tags_created' "$STATS_FILE")
  
  # Last 30 days stats
  # NOTE: date command syntax differs between GNU and BSD, handle both
  local last_30_days=$(date -d "30 days ago" +%Y-%m-%d 2>/dev/null || date -v-30d +%Y-%m-%d)
  local recent_commits=$(jq -r --arg date "$last_30_days" '
    .daily_stats | to_entries | 
    map(select(.key >= $date) | .value.commits // 0) | 
    add // 0
  ' "$STATS_FILE")
  
  echo -e " ${GREEN}Commits totaux :${NC} $total_commits"
  echo -e " ${GREEN}Pushes :${NC} $total_pushes"
  echo -e " ${GREEN}Issues créées :${NC} $issues_created"
  echo -e " ${GREEN}Issues fermées :${NC} $issues_closed"
  echo -e " ${GREEN}Commits AI :${NC} $ai_commits"
  echo -e "  ${GREEN}Tags créés :${NC} $tags_created"
  
  echo -e "\n${YELLOW} Derniers 30 jours${NC}"
  echo -e "  Commits : $recent_commits"
  echo -e "  Moyenne/jour : $((recent_commits / 30))"
  
  # Find most productive hour
  local prod_hour=$(jq -r '
    .daily_stats | to_entries | 
    map(.value.hours // {} | to_entries) | 
    flatten | 
    group_by(.key) | 
    map({hour: .[0].key, count: (map(.value) | add)}) | 
    max_by(.count) | 
    .hour // "N/A"
  ' "$STATS_FILE")
  
  echo -e "  Heure productive : ${prod_hour}h00"
  
  # Show streak
  calculate_streak
  
  # AI usage percentage
  if [[ $total_commits -gt 0 ]]; then
    local ai_percentage=$((ai_commits * 100 / total_commits))
    echo -e "\n${CYAN} Utilisation AI : ${ai_percentage}%${NC}"
    
    # Progress bar
    draw_progress_bar $ai_percentage 30
  fi
}

# Calculate commit streak
calculate_streak() {
  local today=$(date +%Y-%m-%d)
  local streak=0
  local current_date="$today"
  
  while true; do
    local commits=$(jq -r --arg date "$current_date" '.daily_stats[$date].commits // 0' "$STATS_FILE")
    if [[ $commits -gt 0 ]]; then
      ((streak++))
      current_date=$(date -d "$current_date - 1 day" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d)
    else
      break
    fi
  done
  
  if [[ $streak -gt 0 ]]; then
    echo -e "\n ${GREEN}Streak actuel : $streak jours !${NC}"
  fi
}

# Draw progress bar
draw_progress_bar() {
  local percentage=$1
  local width=$2
  local filled=$((percentage * width / 100))
  local empty=$((width - filled))
  
  echo -n "["
  printf "%${filled}s" | tr ' ' '█'
  printf "%${empty}s" | tr ' ' '░'
  echo "]"
}

# Show team stats (mock for now)
show_team_stats() {
  echo -e "\n${MAGENTA} Statistiques d'Équipe${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  # TODO: implement real team stats once we have a backend
  # Mock data for demo
  echo -e " ${YELLOW}Top Contributors (Cette semaine)${NC}"
  echo -e "  Alice : 47 commits"
  echo -e "  Bob : 31 commits"
  echo -e "  Charlie : 28 commits"
  echo -e "  Toi : 23 commits (#4)"
  
  echo -e "\n ${YELLOW}Métriques du Projet${NC}"
  echo -e "  Fichier le plus modifié : src/main.js (89 changes)"
  echo -e "  Vélocité :  +23% vs semaine dernière"
  echo -e "  Completion sprint : 78%"
  echo -e "  Bugs résolus : 12/15"
  
  echo -e "\n ${YELLOW}Achievements débloqués${NC}"
  echo -e "  Early Bird (commit avant 7h)"
  echo -e "  Night Owl (commit après 23h)"
  echo -e "  Productivity Master (30+ commits/semaine)"
}

# Export weekly report
export_weekly_report() {
  # BUG: report template has hardcoded placeholders X, Y, Z
  local report_file="$HOME/.gitpush/weekly_report_$(date +%Y-%m-%d).md"
  
  cat > "$report_file" << 'EOF'
# Gitpush Weekly Report

**Period**: Last 7 days  
**Generated**: $(date)

##  Personal Stats
- Total commits: X
- Issues closed: Y
- AI usage: Z%

##  Achievements
- [x] Maintained daily streak
- [x] Used AI for complex commits
- [ ] Created 10+ issues

##  Insights
- Most productive hour: 14h00
- Favorite branch type: feature/
- Average commits/day: 8

---
Generated by Gitpush Analytics
EOF

  echo -e "${GREEN} Rapport exporté : $report_file${NC}"
}

# Main analytics menu
analytics_menu() {
  echo -e "\n${MAGENTA} Gitpush Analytics${NC}"
  
  PS3=$'\n Que veux-tu analyser ? '
  options=(
    " Mes statistiques"
    " Stats de l'équipe"
    " Graphiques"
    " Exporter rapport"
    " Rafraîchir"
    " Retour"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        show_personal_stats
        ;;
      2)
        show_team_stats
        ;;
      3)
        echo -e "${CYAN} Ouverture du dashboard web...${NC}"
        echo -e "${YELLOW}(Feature coming in v0.6.0)${NC}"
        ;;
      4)
        export_weekly_report
        ;;
      5)
        echo -e "${CYAN} Rafraîchissement...${NC}"
        analytics_menu
        break
        ;;
      6)
        break
        ;;
      *)
        echo -e "${RED} Choix invalide${NC}"
        ;;
    esac
    echo
  done
}

# Export functions
export -f init_stats
export -f record_commit
export -f record_ai_usage
export -f show_personal_stats
export -f show_team_stats
export -f analytics_menu