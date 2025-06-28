# Quick Start Guide

Get up and running with gitpush in less than 5 minutes.

## Prerequisites

- **Git** (v2.0+)
- **Bash** shell
- **curl** (for installation)
- **jq** (for JSON processing)
- **GitHub CLI** (optional, for issue management)

## 1. Installation

### One-line Install (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/Karlblock/gitpush.git
cd gitpush
./install.sh
```

### Verify Installation
```bash
gitpush --version
# Should output: gitpush v1.0.0-beta
```

## 2. First Run

Navigate to any Git repository and run:
```bash
gitpush
```

You'll see the interactive menu:
```
Main Menu
1) 🚀 Complete Git workflow
2) 📋 Issue management  
3) 🤖 AI assistant
4) 📊 Analytics
5) ❌ Exit

👉 Your choice:
```

Choose **option 1** for the basic workflow.

## 3. Basic Workflow

The standard gitpush workflow:

1. **Branch check**: Shows current branch and repository
2. **Commit message**: Enter a descriptive commit message
3. **Pull option**: Choose whether to pull before pushing
4. **Tag creation**: Optionally create a version tag
5. **GitHub release**: Create a GitHub release (if tag was created)
6. **Execution**: Runs all selected actions

## 4. AI Configuration (Optional)

To use AI features, you need an API key from one of the supported providers.

### OpenAI Setup
1. Get an API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Configure gitpush:
```bash
gitpush --ai --configure
# Select "OpenAI (GPT-4)"
# Enter your API key when prompted
```

### Anthropic Setup
1. Get an API key from [Anthropic Console](https://console.anthropic.com/)
2. Configure gitpush:
```bash
gitpush --ai --configure
# Select "Anthropic (Claude)"
# Enter your API key when prompted
```

### Local AI (Ollama)
1. Install [Ollama](https://ollama.ai)
2. Pull a code model:
```bash
ollama pull codellama
```
3. Configure gitpush:
```bash
gitpush --ai --configure
# Select "Local (Ollama)"
```

## 5. First AI Commit

Once AI is configured, try:
```bash
# Make some changes to your code
echo "console.log('Hello World');" > hello.js

# Use AI to generate commit message
gitpush --ai-commit
```

The AI will analyze your changes and suggest a commit message like:
```
feat: add hello world script

- Add basic JavaScript hello world example
- Set up initial project structure
```

## 6. Common Commands

```bash
# Interactive mode
gitpush

# Quick commit with message
gitpush -m "fix: resolve login bug" --yes

# AI-powered workflow
gitpush --ai-commit

# Manage GitHub issues
gitpush --issues

# View your Git statistics
gitpush --stats

# Simulation mode (preview actions)
gitpush --simulate -m "test commit"

# Get help
gitpush --help
```

## 7. GitHub Integration

To use issue management and releases:

1. Install [GitHub CLI](https://cli.github.com/)
2. Authenticate:
```bash
gh auth login
```
3. Test issue management:
```bash
gitpush --issues
```

## 8. Configuration Files

Gitpush creates these configuration files:

- `~/.gitpush/.env` - Environment variables (API keys, settings)
- `~/.gitpush/stats.json` - Personal Git statistics
- `~/.gitpush/plugins/` - Installed plugins

## 9. What's Next?

- **Read the full documentation**: [README.md](../README.md)
- **Set up AI providers**: [AI Setup Guide](AI_SETUP.md)
- **Explore team features**: `gitpush --team`
- **Try the desktop GUI**: `gitpush --gui`
- **Develop plugins**: [Plugin Development Guide](PLUGIN_DEVELOPMENT.md)

## Troubleshooting

### Command not found
```bash
# Add to PATH manually
export PATH="$HOME/.local/bin:$PATH"

# Or restart your terminal
```

### AI not working
```bash
# Check configuration
cat ~/.gitpush/.env

# Test AI availability
gitpush --ai
```

### Permission issues
```bash
# Make sure scripts are executable
chmod +x ~/.gitpush/gitpush.sh
chmod +x ~/.gitpush/lib/**/*.sh
```

### GitHub CLI issues
```bash
# Check authentication
gh auth status

# Re-authenticate if needed
gh auth login
```

---

**Need help?** Open an [issue](https://github.com/Karlblock/gitpush/issues) or check the [documentation](../README.md).