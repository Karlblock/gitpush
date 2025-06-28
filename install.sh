#!/bin/bash

# Gitpush Installation Script
# Usage: curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash

set -e

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
NC="\033[0m"

# Configuration
REPO_URL="https://github.com/Karlblock/gitpush.git"
INSTALL_DIR="$HOME/.gitpush"
BIN_DIR="$HOME/.local/bin"
VERSION="v1.0.0-beta"

# System detection
detect_system() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    # Essential dependencies
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${RED}Missing required dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Please install them first:${NC}"
        
        local system=$(detect_system)
        case $system in
            "linux")
                echo "  sudo apt update && sudo apt install git curl jq"
                echo "  # or: sudo yum install git curl jq"
                ;;
            "macos")
                echo "  brew install git curl jq"
                ;;
            "windows")
                echo "  # Use Git Bash or WSL with Linux instructions"
                ;;
        esac
        
        exit 1
    fi
}

# Create directories
setup_directories() {
    echo -e "${CYAN}Setting up directories...${NC}"
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$BIN_DIR"
    mkdir -p "$HOME/.gitpush"
    
    # Add bin directory to PATH if not already there
    local shell_rc=""
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        shell_rc="$HOME/.bashrc"
    fi
    
    if [[ -n "$shell_rc" ]] && [[ -f "$shell_rc" ]]; then
        if ! grep -q "$BIN_DIR" "$shell_rc"; then
            echo "" >> "$shell_rc"
            echo "# Added by gitpush installer" >> "$shell_rc"
            echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$shell_rc"
            echo -e "${YELLOW}Added $BIN_DIR to PATH in $shell_rc${NC}"
            echo -e "${YELLOW}Run 'source $shell_rc' or restart your terminal${NC}"
        fi
    fi
}

# Download and install
install_gitpush() {
    echo -e "${CYAN}Installing gitpush $VERSION...${NC}"
    
    # Remove existing installation
    if [[ -d "$INSTALL_DIR" ]]; then
        echo -e "${YELLOW}Removing existing installation...${NC}"
        rm -rf "$INSTALL_DIR"
    fi
    
    # Clone repository
    echo -e "${CYAN}Downloading from GitHub...${NC}"
    git clone --branch release/v1.0.0 --depth 1 "$REPO_URL" "$INSTALL_DIR"
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR/gitpush.sh"
    find "$INSTALL_DIR/lib" -name "*.sh" -exec chmod +x {} \;
    find "$INSTALL_DIR/tests" -name "*.sh" -exec chmod +x {} \;
    
    # Create symlink
    ln -sf "$INSTALL_DIR/gitpush.sh" "$BIN_DIR/gitpush"
    
    echo -e "${GREEN}Installation completed!${NC}"
}

# Setup configuration
setup_config() {
    echo -e "${CYAN}Setting up configuration...${NC}"
    
    # Copy example files
    if [[ ! -f "$HOME/.gitpush/.env" ]] && [[ -f "$INSTALL_DIR/.env.example" ]]; then
        cp "$INSTALL_DIR/.env.example" "$HOME/.gitpush/.env"
        echo -e "${YELLOW}Created .env file at $HOME/.gitpush/.env${NC}"
        echo -e "${YELLOW}Edit it to configure AI providers${NC}"
    fi
    
    # Initialize stats
    if [[ ! -f "$HOME/.gitpush/stats.json" ]]; then
        echo '{"total_commits": 0, "total_pushes": 0, "ai_commits": 0, "daily_stats": {}}' > "$HOME/.gitpush/stats.json"
    fi
}

# Run tests
run_tests() {
    echo -e "${CYAN}Running quick verification...${NC}"
    
    if "$INSTALL_DIR/gitpush.sh" --version >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Gitpush command works${NC}"
    else
        echo -e "${RED}✗ Gitpush command failed${NC}"
        return 1
    fi
    
    # Optional: Run full test suite
    read -p "Run full test suite? (y/N): " run_full_tests
    if [[ "$run_full_tests" =~ ^[yY]$ ]]; then
        cd "$INSTALL_DIR/tests" && ./run_tests.sh
    fi
}

# Post-install configuration
post_install() {
    echo -e "\n${GREEN}🎉 Gitpush $VERSION installed successfully!${NC}\n"
    
    echo -e "${CYAN}Quick start:${NC}"
    echo "  gitpush --help                 # Show help"
    echo "  gitpush                        # Interactive mode"
    echo "  gitpush --ai                   # AI assistant"
    echo ""
    
    echo -e "${CYAN}Configuration:${NC}"
    echo "  Edit ~/.gitpush/.env           # Configure AI providers"
    echo "  gitpush --ai --configure       # Interactive AI setup"
    echo ""
    
    echo -e "${CYAN}Documentation:${NC}"
    echo "  cat $INSTALL_DIR/docs/AI_SETUP.md  # AI configuration guide"
    echo "  cat $INSTALL_DIR/README.md          # Full documentation"
    echo ""
    
    # Check if gitpush is in PATH
    if command -v gitpush >/dev/null 2>&1; then
        echo -e "${GREEN}✓ gitpush is ready to use!${NC}"
    else
        echo -e "${YELLOW}⚠ You may need to restart your terminal or run:${NC}"
        echo "  export PATH=\"$BIN_DIR:\$PATH\""
    fi
    
    # Offer to configure AI
    echo ""
    read -p "Configure AI now? (y/N): " setup_ai
    if [[ "$setup_ai" =~ ^[yY]$ ]]; then
        "$BIN_DIR/gitpush" --ai --configure
    fi
}

# Error handling
cleanup_on_error() {
    echo -e "\n${RED}Installation failed!${NC}"
    echo -e "${YELLOW}Cleaning up...${NC}"
    
    # Remove partial installation
    [[ -d "$INSTALL_DIR" ]] && rm -rf "$INSTALL_DIR"
    [[ -L "$BIN_DIR/gitpush" ]] && rm -f "$BIN_DIR/gitpush"
    
    echo -e "${YELLOW}Please check the error above and try again.${NC}"
    echo -e "${YELLOW}For help, visit: https://github.com/Karlblock/gitpush/issues${NC}"
}

# Main installation flow
main() {
    echo -e "${BLUE}"
    cat << 'EOF'
         _ __                   __  
  ____ _(_) /_____  __  _______/ /_ 
 / __ `/ / __/ __ \/ / / / ___/ __ \
/ /_/ / / /_/ /_/ / /_/ (__  ) / / / 
\__, /_/\__/ .___/\__,_/____/_/ /_/  
/____/     /_/                        

EOF
    echo -e "${NC}"
    echo -e "${CYAN}Gitpush Installer $VERSION${NC}"
    echo -e "${CYAN}Smart Git workflow automation with AI${NC}"
    echo ""
    
    # Trap errors
    trap cleanup_on_error ERR
    
    # Check system compatibility
    local system=$(detect_system)
    echo -e "${CYAN}Detected system: $system${NC}"
    
    if [[ "$system" == "unknown" ]]; then
        echo -e "${YELLOW}Warning: Untested system. Installation may not work correctly.${NC}"
        read -p "Continue anyway? (y/N): " continue_install
        [[ ! "$continue_install" =~ ^[yY]$ ]] && exit 1
    fi
    
    # Installation steps
    check_dependencies
    setup_directories
    install_gitpush
    setup_config
    run_tests
    post_install
    
    echo -e "\n${GREEN}🚀 Happy git-ing with gitpush!${NC}"
}

# Run installer
main "$@"