#!/bin/bash

# 🔌 Gitpush Plugin Manager
# Extensibility system for gitpush

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
NC="\033[0m"

# Plugin directories
PLUGIN_DIR="$HOME/.gitpush/plugins"
SYSTEM_PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../plugins"
PLUGIN_REGISTRY="https://api.gitpush.dev/plugins"

# Plugin hooks
declare -A HOOKS
HOOKS=(
  ["pre-commit"]=""
  ["post-commit"]=""
  ["pre-push"]=""
  ["post-push"]=""
  ["pre-tag"]=""
  ["post-tag"]=""
  ["pre-issue"]=""
  ["post-issue"]=""
)

# Initialize plugin system
init_plugins() {
  mkdir -p "$PLUGIN_DIR"
  
  # Create plugin manifest if not exists
  if [[ ! -f "$PLUGIN_DIR/manifest.json" ]]; then
    echo '{"installed": [], "enabled": []}' > "$PLUGIN_DIR/manifest.json"
  fi
}

# Load all enabled plugins
load_plugins() {
  init_plugins
  
  local enabled_plugins=$(jq -r '.enabled[]' "$PLUGIN_DIR/manifest.json" 2>/dev/null)
  
  for plugin in $enabled_plugins; do
    load_single_plugin "$plugin"
  done
}

# Load a single plugin
load_single_plugin() {
  local plugin_name="$1"
  local plugin_path=""
  
  # Check user plugins first
  if [[ -f "$PLUGIN_DIR/$plugin_name/plugin.sh" ]]; then
    plugin_path="$PLUGIN_DIR/$plugin_name/plugin.sh"
  elif [[ -f "$SYSTEM_PLUGIN_DIR/$plugin_name/plugin.sh" ]]; then
    plugin_path="$SYSTEM_PLUGIN_DIR/$plugin_name/plugin.sh"
  else
    echo -e "${YELLOW}⚠️ Plugin '$plugin_name' not found${NC}"
    return 1
  fi
  
  # Source the plugin
  source "$plugin_path"
  
  # Register hooks if plugin has them
  if type -t "${plugin_name}_register_hooks" &>/dev/null; then
    "${plugin_name}_register_hooks"
  fi
  
  return 0
}

# Register a hook
register_hook() {
  local hook_name="$1"
  local function_name="$2"
  
  if [[ -n "${HOOKS[$hook_name]}" ]]; then
    HOOKS[$hook_name]="${HOOKS[$hook_name]}:$function_name"
  else
    HOOKS[$hook_name]="$function_name"
  fi
}

# Execute hooks
execute_hook() {
  local hook_name="$1"
  shift
  local args="$@"
  
  local functions="${HOOKS[$hook_name]}"
  if [[ -z "$functions" ]]; then
    return 0
  fi
  
  IFS=':' read -ra FUNCS <<< "$functions"
  for func in "${FUNCS[@]}"; do
    if type -t "$func" &>/dev/null; then
      "$func" $args
    fi
  done
}

# List available plugins
list_plugins() {
  echo -e "\n${MAGENTA}🔌 Plugins Disponibles${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  
  # System plugins
  echo -e "\n${YELLOW}Plugins Système :${NC}"
  if [[ -d "$SYSTEM_PLUGIN_DIR" ]]; then
    for plugin in "$SYSTEM_PLUGIN_DIR"/*; do
      if [[ -d "$plugin" && -f "$plugin/plugin.json" ]]; then
        local name=$(basename "$plugin")
        local desc=$(jq -r '.description' "$plugin/plugin.json" 2>/dev/null || echo "No description")
        local version=$(jq -r '.version' "$plugin/plugin.json" 2>/dev/null || echo "?")
        echo -e "  📦 ${GREEN}$name${NC} (v$version) - $desc"
      fi
    done
  fi
  
  # User plugins
  echo -e "\n${YELLOW}Plugins Utilisateur :${NC}"
  if [[ -d "$PLUGIN_DIR" ]]; then
    for plugin in "$PLUGIN_DIR"/*; do
      if [[ -d "$plugin" && -f "$plugin/plugin.json" ]]; then
        local name=$(basename "$plugin")
        local desc=$(jq -r '.description' "$plugin/plugin.json" 2>/dev/null)
        local version=$(jq -r '.version' "$plugin/plugin.json" 2>/dev/null)
        local enabled=$(jq -r --arg name "$name" '.enabled | contains([$name])' "$PLUGIN_DIR/manifest.json")
        
        if [[ "$enabled" == "true" ]]; then
          echo -e "  ✅ ${GREEN}$name${NC} (v$version) - $desc"
        else
          echo -e "  ⭕ ${YELLOW}$name${NC} (v$version) - $desc"
        fi
      fi
    done
  fi
}

# Install a plugin
install_plugin() {
  local plugin_name="$1"
  
  echo -e "${CYAN}📥 Installation du plugin '$plugin_name'...${NC}"
  
  # Check if it's a URL
  if [[ "$plugin_name" =~ ^https?:// ]]; then
    # Download from URL
    local temp_dir=$(mktemp -d)
    git clone "$plugin_name" "$temp_dir" 2>/dev/null
    
    if [[ -f "$temp_dir/plugin.json" ]]; then
      local name=$(jq -r '.name' "$temp_dir/plugin.json")
      mv "$temp_dir" "$PLUGIN_DIR/$name"
      
      # Update manifest
      jq --arg name "$name" '.installed += [$name]' "$PLUGIN_DIR/manifest.json" > "$PLUGIN_DIR/manifest.json.tmp" && \
        mv "$PLUGIN_DIR/manifest.json.tmp" "$PLUGIN_DIR/manifest.json"
      
      echo -e "${GREEN}✅ Plugin '$name' installé !${NC}"
    else
      echo -e "${RED}❌ Invalid plugin structure${NC}"
      rm -rf "$temp_dir"
    fi
  else
    # Install from registry (future feature)
    echo -e "${YELLOW}⚠️ Plugin registry not yet available${NC}"
  fi
}

# Enable/disable plugin
toggle_plugin() {
  local plugin_name="$1"
  local action="$2"  # enable or disable
  
  if [[ "$action" == "enable" ]]; then
    jq --arg name "$plugin_name" '.enabled += [$name] | .enabled |= unique' "$PLUGIN_DIR/manifest.json" > "$PLUGIN_DIR/manifest.json.tmp" && \
      mv "$PLUGIN_DIR/manifest.json.tmp" "$PLUGIN_DIR/manifest.json"
    echo -e "${GREEN}✅ Plugin '$plugin_name' activé${NC}"
  else
    jq --arg name "$plugin_name" '.enabled -= [$name]' "$PLUGIN_DIR/manifest.json" > "$PLUGIN_DIR/manifest.json.tmp" && \
      mv "$PLUGIN_DIR/manifest.json.tmp" "$PLUGIN_DIR/manifest.json"
    echo -e "${YELLOW}⭕ Plugin '$plugin_name' désactivé${NC}"
  fi
}

# Plugin management menu
plugin_menu() {
  echo -e "\n${MAGENTA}🔌 Gestion des Plugins${NC}"
  
  PS3=$'\n👉 Que veux-tu faire ? '
  options=(
    "📋 Lister les plugins"
    "📥 Installer un plugin"
    "✅ Activer un plugin"
    "❌ Désactiver un plugin"
    "🗑️ Désinstaller un plugin"
    "🔄 Recharger les plugins"
    "🔙 Retour"
  )
  
  select opt in "${options[@]}"; do
    case $REPLY in
      1)
        list_plugins
        ;;
      2)
        read -p "📦 URL ou nom du plugin : " plugin_url
        install_plugin "$plugin_url"
        ;;
      3)
        read -p "📦 Nom du plugin à activer : " plugin_name
        toggle_plugin "$plugin_name" "enable"
        ;;
      4)
        read -p "📦 Nom du plugin à désactiver : " plugin_name
        toggle_plugin "$plugin_name" "disable"
        ;;
      5)
        read -p "📦 Nom du plugin à désinstaller : " plugin_name
        rm -rf "$PLUGIN_DIR/$plugin_name"
        echo -e "${GREEN}✅ Plugin désinstallé${NC}"
        ;;
      6)
        load_plugins
        echo -e "${GREEN}✅ Plugins rechargés${NC}"
        ;;
      7)
        break
        ;;
      *)
        echo -e "${RED}❌ Choix invalide${NC}"
        ;;
    esac
    echo
  done
}

# Export functions
export -f init_plugins
export -f load_plugins
export -f register_hook
export -f execute_hook
export -f plugin_menu