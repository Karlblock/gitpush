#!/bin/bash

# gitpush - Smart Git workflow automation
# Version: 1.2.0
# Author: Karl Block

GITPUSH_VERSION="v1.2.0"
SIMULATE=false
AUTO_CONFIRM=false
MSG=""
DO_SYNC="N"
DO_TAG="N"
CUSTOM_TAG=""
DO_RELEASE="N"
NEW_TAG=""
DO_ISSUES="N"
CLOSE_ISSUE=""

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m"

# Default issue labels
DEFAULT_LABELS=("bug" "enhancement" "feature" "documentation" "question")

# Load environment config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/.env" ]]; then
  export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs) 2>/dev/null
elif [[ -f "$HOME/.gitpush/.env" ]]; then
  export $(grep -v '^#' "$HOME/.gitpush/.env" | xargs) 2>/dev/null
fi

# Load modules if available
AI_AVAILABLE=false
ANALYTICS_AVAILABLE=false
TEAM_AVAILABLE=false

[[ -f "$SCRIPT_DIR/lib/ai/ai_manager.sh" ]] && source "$SCRIPT_DIR/lib/ai/ai_manager.sh" && AI_AVAILABLE=true
[[ -f "$SCRIPT_DIR/lib/analytics/stats_manager.sh" ]] && source "$SCRIPT_DIR/lib/analytics/stats_manager.sh" && ANALYTICS_AVAILABLE=true
[[ -f "$SCRIPT_DIR/lib/team/team_manager.sh" ]] && source "$SCRIPT_DIR/lib/team/team_manager.sh" && TEAM_AVAILABLE=true

# Helper function to run commands
run_command() {
  local error_msg="${!#}"
  local cmd_args=("${@:1:$#-1}")

  if $SIMULATE; then
    echo -e "${CYAN}Simulate:${NC} ${cmd_args[*]}"
    return 0
  fi
  
  echo -e "${CYAN}Executing:${NC} ${cmd_args[*]}"
  
  local output
  output=$("${cmd_args[@]}" 2>&1)
  local exit_code=$?
  
  if [ $exit_code -ne 0 ]; then
    echo -e "${RED}Error:${NC} $error_msg"
    echo -e "${YELLOW}Output:${NC} $output"
    
    if ! $AUTO_CONFIRM; then
      read -p "Continue anyway? (y/N): " continue_on_error
      [[ ! "$continue_on_error" =~ ^[yY]$ ]] && exit 1
    else
      exit 1
    fi
  else
    [[ -n "$output" ]] && echo "$output"
  fi
  
  return $exit_code
}

# Display banner
display_banner() {
  clear
  cat << "EOF"
          _ __                   __  
   ____ _(_) /_____  __  _______/ /_ 
  / __ `/ / __/ __ \/ / / / ___/ __ \
 / /_/ / / /_/ /_/ / /_/ (__  ) / / / 
 \__, /_/\__/ .___/\__,_/____/_/ /_/  
/____/     /_/                        

        gitpush — by Karl Block
EOF
  echo -e "${CYAN}Gitpush ${MAGENTA}$GITPUSH_VERSION${NC} - Git workflow automation"
}

# Parse command line arguments
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
        echo "  --version      Show version"
        echo "  --help         Show this help"
        echo "  --simulate     Preview actions without executing"
        echo "  --yes          Execute all actions without confirmation"
        echo "  --message|-m   Commit message (for non-interactive mode)"
        echo "  --issues       GitHub issues management"
        echo "  --ai-commit    Generate commit message with AI"
        echo "  --stats        Show statistics"
        echo "  --test         Run tests"
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
          shift 2
        else
          echo -e "${RED}Error:${NC} --message requires a value."
          exit 1
        fi
        ;;
      --issues)
        issues_management
        exit 0
        ;;
      --ai-commit)
        if $AI_AVAILABLE; then
          USE_AI_COMMIT=true
        else
          echo -e "${RED}AI not configured. Set up .env file with API keys.${NC}"
          exit 1
        fi
        shift
        ;;
      --stats)
        if $ANALYTICS_AVAILABLE; then
          analytics_menu
        else
          echo -e "${RED}Analytics module not found${NC}"
        fi
        exit 0
        ;;
      --test)
        echo -e "${CYAN}Running tests...${NC}"
        cd "$SCRIPT_DIR/tests" && ./run_tests.sh
        exit $?
        ;;
      *)
        shift
        ;;
    esac
  done
}

# Get Git context
get_git_context() {
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -z "$current_branch" ]; then
    echo -e "${RED}Error:${NC} Not a git repository"
    exit 1
  fi
  
  repo_name=$(basename -s .git "$(git config --get remote.origin.url 2>/dev/null)")

  echo -e "\n📍 Current branch: ${MAGENTA}$current_branch${NC}"
  echo -e "📦 Repository: ${CYAN}${repo_name:-Unknown}${NC}"
}

# Check GitHub CLI
check_gh_cli() {
  if ! command -v gh &> /dev/null; then
    echo -e "${RED}GitHub CLI (gh) not installed.${NC}"
    echo -e "${YELLOW}Install: https://cli.github.com/${NC}"
    return 1
  fi
  return 0
}

# Simple issues management
issues_management() {
  if ! check_gh_cli; then return 1; fi
  
  display_banner
  echo -e "\n${MAGENTA}GitHub Issues Management${NC}"
  
  PS3=$'\nYour choice: '
  options=("List open issues" "Create new issue" "Close issue" "Back")
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        echo -e "\n${CYAN}Open Issues:${NC}"
        gh issue list --limit 10
        ;;
      2)
        read -p "Issue title: " title
        [[ -z "$title" ]] && { echo -e "${RED}Title required${NC}"; continue; }
        read -p "Description (optional): " desc
        
        local cmd="gh issue create --title \"$title\""
        [[ -n "$desc" ]] && cmd+=" --body \"$desc\""
        
        if $SIMULATE; then
          echo -e "${CYAN}Simulate:${NC} $cmd"
        else
          eval "$cmd"
        fi
        ;;
      3)
        gh issue list --limit 10
        read -p "Issue number to close: " issue_num
        if [[ "$issue_num" =~ ^[0-9]+$ ]]; then
          if $SIMULATE; then
            echo -e "${CYAN}Simulate:${NC} gh issue close $issue_num"
          else
            gh issue close "$issue_num"
          fi
        fi
        ;;
      4)
        break
        ;;
    esac
  done
}

# Handle critical branches
handle_critical_branch() {
  if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    echo -e "${RED}Warning: You're on branch $current_branch${NC}"
    if ! $AUTO_CONFIRM; then
      read -p "Continue anyway? (y/N): " confirm_main
      if [[ ! "$confirm_main" =~ ^[yY]$ ]]; then
        echo -e "${RED}Operation cancelled${NC}"
        
        echo -e "\nAvailable branches:"
        git branch --format="%(refname:short)" | grep -vE "^(main|master)$"
        
        read -p "Switch to branch (or 'q' to quit): " new_branch
        if [[ "$new_branch" == "q" ]]; then
          exit 0
        elif [[ -n "$new_branch" ]]; then
          git switch "$new_branch" && current_branch="$new_branch"
        else
          exit 0
        fi
      fi
    fi
  fi
}

# Get user inputs
get_user_inputs() {
  if [ -z "$MSG" ]; then
    # AI commit if available and requested
    if [[ "${USE_AI_COMMIT:-false}" == "true" ]] && $AI_AVAILABLE; then
      echo -e "${CYAN}Generating AI commit message...${NC}"
      local diff=$(git diff --cached)
      [[ -z "$diff" ]] && diff=$(git diff)
      
      if [[ -n "$diff" ]] && command -v generate_commit_message &>/dev/null; then
        local ai_msg=$(generate_commit_message "$diff" 2>/dev/null | tail -n1)
        if [[ -n "$ai_msg" && "$ai_msg" != "false" ]]; then
          echo -e "${GREEN}AI suggestion:${NC} $ai_msg"
          read -p "Use this message? [Enter to accept]: " user_msg
          MSG="${user_msg:-$ai_msg}"
        fi
      fi
    fi
    
    # Manual input if no AI message
    if [[ -z "$MSG" ]]; then
      read -p "Commit message: " MSG
      while [[ -z "$MSG" || ${#MSG} -lt 3 ]]; do
        echo -e "${RED}Message must be at least 3 characters${NC}"
        read -p "Commit message: " MSG
      done
    fi
  fi
  
  # Auto-detect issue keywords
  local keywords=("fix" "fixes" "close" "closes" "resolve" "resolves")
  for keyword in "${keywords[@]}"; do
    if [[ "$MSG" =~ $keyword[[:space:]]+#([0-9]+) ]]; then
      local issue_num="${BASH_REMATCH[1]}"
      echo -e "${YELLOW}Detected: This commit will close issue #$issue_num${NC}"
      if ! $AUTO_CONFIRM; then
        read -p "Confirm closing issue #$issue_num? (y/N): " confirm_close
        [[ "$confirm_close" =~ ^[yY]$ ]] && CLOSE_ISSUE="$issue_num"
      else
        CLOSE_ISSUE="$issue_num"
      fi
      break
    fi
  done

  if ! $AUTO_CONFIRM; then
    read -p "Pull --rebase before push? (y/N): " DO_SYNC
    read -p "Create tag? (y/N): " DO_TAG
    if [[ "$DO_TAG" =~ ^[yY]$ ]]; then
      read -p "Custom tag (or auto): " CUSTOM_TAG
    fi
    read -p "Create GitHub Release? (y/N): " DO_RELEASE
    
    if check_gh_cli &>/dev/null; then
      read -p "Access Issues menu? (y/N): " DO_ISSUES
      [[ "$DO_ISSUES" =~ ^[yY]$ ]] && issues_management
    fi
  else
    DO_SYNC="Y"
    DO_TAG="Y"
    CUSTOM_TAG="auto"
    DO_RELEASE="Y"
  fi
}

# Summarize actions
summarize_and_confirm() {
  echo -e "\n📦 Summary:"
  echo -e "• Commit: ${GREEN}$MSG${NC}"
  [[ "$DO_SYNC" =~ ^[yY]$ ]] && echo -e "• Pull: ${CYAN}enabled${NC}" || echo -e "• Pull: disabled"
  [[ "$DO_TAG" =~ ^[yY]$ ]] && echo -e "• Tag: ${YELLOW}${CUSTOM_TAG:-auto}${NC}" || echo -e "• Tag: none"
  [[ "$DO_RELEASE" =~ ^[yY]$ ]] && echo -e "• Release: ${CYAN}yes${NC}" || echo -e "• Release: no"
  [[ -n "$CLOSE_ISSUE" ]] && echo -e "• Close issue: ${YELLOW}#$CLOSE_ISSUE${NC}"

  if ! $AUTO_CONFIRM; then
    read -p $'\nConfirm and proceed? (y/N): ' confirm_run
    [[ "$confirm_run" =~ ^[yY]$ ]] || { echo -e "${RED}Cancelled${NC}"; exit 1; }
  fi
}

# Perform Git actions
perform_git_actions() {
  run_command git add . "Failed to add files"
  run_command git commit -m "$MSG" "Failed to commit"
  
  # Track in analytics if available
  $ANALYTICS_AVAILABLE && command -v record_commit &>/dev/null && record_commit
  
  [[ "$DO_SYNC" =~ ^[yY]$ ]] && run_command git pull --rebase "Failed to pull --rebase"
  run_command git push "Failed to push"
  
  # Close issue if detected
  if [[ -n "$CLOSE_ISSUE" ]] && check_gh_cli &>/dev/null; then
    if $SIMULATE; then
      echo -e "${CYAN}Simulate:${NC} gh issue close $CLOSE_ISSUE"
    else
      gh issue close "$CLOSE_ISSUE" --comment "Fixed by: $MSG" &>/dev/null &&
        echo -e "${GREEN}Issue #$CLOSE_ISSUE closed${NC}"
    fi
  fi
}

# Handle tagging
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
      echo -e "${RED}Tag $NEW_TAG already exists${NC}"
    else
      run_command git tag "$NEW_TAG" "Failed to create tag"
      run_command git push origin "$NEW_TAG" "Failed to push tag"
      echo -e "${GREEN}Tag $NEW_TAG created${NC}"

      # Update CHANGELOG if exists
      if [[ -f "CHANGELOG.md" ]] && ! grep -q "^## $NEW_TAG" CHANGELOG.md; then
        echo -e "## $NEW_TAG - $(date +%F)\n- $MSG\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md
        run_command git add CHANGELOG.md "Failed to add CHANGELOG"
        run_command git commit -m "docs: update CHANGELOG for $NEW_TAG" "Failed to commit CHANGELOG"
        run_command git push "Failed to push CHANGELOG"
      fi
    fi
  fi
}

# Create GitHub Release
create_github_release() {
  if [[ "$DO_RELEASE" =~ ^[yY]$ ]] && command -v gh &> /dev/null; then
    if [[ -n "$NEW_TAG" ]] && git tag | grep -q "^$NEW_TAG$"; then
      run_command gh release create "$NEW_TAG" --title "$NEW_TAG" --generate-notes "Failed to create release"
    else
      echo -e "${YELLOW}No release created (missing tag)${NC}"
    fi
  fi
}

# Open GitHub page
open_github_page() {
  local remote_url=$(git config --get remote.origin.url)
  if [[ $remote_url == git@github.com:* ]]; then
    local web_url="https://github.com/${remote_url#git@github.com:}"
    web_url="${web_url%.git}"
    command -v xdg-open &>/dev/null && xdg-open "$web_url" &>/dev/null &
  fi
}

# Main execution
main() {
  parse_args "$@"
  display_banner
  get_git_context

  $SIMULATE && echo -e "\n${CYAN}Simulation mode - no actions will be executed${NC}"

  # Show main menu if interactive
  if [[ -z "$MSG" ]] && ! $AUTO_CONFIRM; then
    echo -e "\n${MAGENTA}Main Menu${NC}"
    PS3=$'\nYour choice: '
    local options=("Complete Git workflow" "Issues management")
    $AI_AVAILABLE && options+=("AI features")
    $ANALYTICS_AVAILABLE && options+=("Analytics")
    options+=("Exit")
    
    select opt in "${options[@]}"; do
      case $REPLY in
        1) break ;;
        2) issues_management; exit 0 ;;
        3) 
          if $AI_AVAILABLE; then
            command -v ai_interactive_mode &>/dev/null && ai_interactive_mode
            exit 0
          elif $ANALYTICS_AVAILABLE; then
            command -v analytics_menu &>/dev/null && analytics_menu
            exit 0
          else
            exit 0
          fi
          ;;
        4)
          if $ANALYTICS_AVAILABLE; then
            command -v analytics_menu &>/dev/null && analytics_menu
            exit 0
          else
            exit 0
          fi
          ;;
        *) exit 0 ;;
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