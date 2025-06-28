# 📦 Gitpush Installation Guide

Multiple ways to install gitpush on your system. Choose the method that works best for you!

## 🚀 Quick Install (Recommended)

```bash
curl -sSL https://gitpush.dev/install.sh | bash
```

This script automatically detects your system and uses the best installation method.

## 📦 Package Managers

### 🍺 Homebrew (macOS/Linux)

```bash
brew tap karlblock/gitpush
brew install gitpush
```

### 📦 APT (Ubuntu/Debian)

```bash
# Add repository
curl -sSL https://gitpush.dev/gpg.key | sudo apt-key add -
echo "deb https://gitpush.dev/apt stable main" | sudo tee /etc/apt/sources.list.d/gitpush.list

# Install
sudo apt update
sudo apt install gitpush
```

### 📦 YUM/DNF (RHEL/Fedora)

```bash
# Add repository
sudo curl -sSL https://gitpush.dev/rpm/gitpush.repo -o /etc/yum.repos.d/gitpush.repo

# Install
sudo yum install gitpush       # RHEL/CentOS
sudo dnf install gitpush       # Fedora
```

### 📦 npm (Node.js)

```bash
npm install -g gitpush-cli
```

## 🔧 Manual Installation

### From Release Archive

```bash
# Download latest release
curl -sSL https://github.com/karlblock/gitpush/archive/v1.0.0.tar.gz | tar xz
cd gitpush-1.0.0

# Install to /usr/local
sudo mkdir -p /usr/local/bin /usr/local/lib/gitpush /usr/local/share/gitpush
sudo cp gitpush.sh /usr/local/bin/gitpush
sudo cp -r lib/* /usr/local/lib/gitpush/
sudo cp -r plugins/* /usr/local/share/gitpush/
sudo chmod +x /usr/local/bin/gitpush

# Cleanup
cd .. && rm -rf gitpush-1.0.0
```

### From Git Repository

```bash
git clone https://github.com/karlblock/gitpush.git
cd gitpush
sudo make install  # Coming soon
```

## 🎯 Platform-Specific Instructions

### 🪟 Windows

#### Option 1: WSL (Recommended)
```bash
# Install WSL first, then use any Linux method above
wsl --install
# Restart and use Ubuntu installation method
```

#### Option 2: Git Bash
```bash
# Download Windows release
curl -sSL https://gitpush.dev/windows/install.ps1 | powershell
```

#### Option 3: Scoop
```bash
scoop bucket add gitpush https://github.com/karlblock/scoop-gitpush
scoop install gitpush
```

### 🍎 macOS

#### Option 1: Homebrew (Recommended)
```bash
brew tap karlblock/gitpush
brew install gitpush
```

#### Option 2: MacPorts
```bash
sudo port install gitpush
```

### 🐧 Linux

Choose the package manager method for your distribution above, or use the universal installer.

## ✅ Verify Installation

```bash
# Check version
gitpush --version

# Test basic functionality
gitpush --help

# Run test suite
gitpush --test
```

## ⚙️ Post-Installation Setup

### 1. Configure AI Providers

```bash
gitpush --configure
```

This will help you set up:
- OpenAI API key
- Anthropic API key  
- Google AI API key
- Local AI (Ollama)

### 2. First Use

```bash
# In any Git repository
gitpush

# Or with AI assistance
gitpush --ai-commit
```

### 3. VS Code Integration

Install the "Gitpush" extension from VS Code marketplace for seamless editor integration.

## 🔧 Configuration Files

After installation, gitpush uses these config locations:

```
~/.gitpush/
├── config          # Main configuration
├── .env            # API keys (secure)
├── stats.json      # Analytics data
└── team.json       # Team settings
```

Example configurations are installed at:
- `/usr/local/share/gitpush/.env.example`
- `/usr/local/share/gitpush/.gitpush.config.example`

## 🚨 Troubleshooting

### Command Not Found

```bash
# Check if installed
which gitpush

# Add to PATH if needed
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Permission Issues

```bash
# Fix executable permissions
sudo chmod +x /usr/local/bin/gitpush

# Fix library permissions
sudo chmod -R 755 /usr/local/lib/gitpush/
```

### AI Features Not Working

```bash
# Check configuration
gitpush --configure

# Test AI connection
gitpush --ai --test
```

## 🔄 Updates

### Homebrew
```bash
brew upgrade gitpush
```

### APT
```bash
sudo apt update && sudo apt upgrade gitpush
```

### npm
```bash
npm update -g gitpush-cli
```

### Manual
```bash
curl -sSL https://gitpush.dev/install.sh | bash
```

## 🗑️ Uninstallation

### Homebrew
```bash
brew uninstall gitpush
brew untap karlblock/gitpush
```

### APT
```bash
sudo apt remove gitpush
sudo rm /etc/apt/sources.list.d/gitpush.list
```

### npm
```bash
npm uninstall -g gitpush-cli
```

### Manual
```bash
sudo rm -f /usr/local/bin/gitpush
sudo rm -rf /usr/local/lib/gitpush
sudo rm -rf /usr/local/share/gitpush
rm -rf ~/.gitpush  # Remove user config
```

## 🆘 Support

- 📚 [Documentation](https://gitpush.dev/docs)
- 🐛 [Issue Tracker](https://github.com/karlblock/gitpush/issues)
- 💬 [Community Discord](https://discord.gg/gitpush)
- 📧 [Email Support](mailto:support@gitpush.dev)

---

**Ready to revolutionize your Git workflow?** Choose your preferred installation method above! 🚀