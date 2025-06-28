# Troubleshooting Guide

Common issues and solutions for gitpush.

## Installation Issues

### Command not found: gitpush

**Problem**: After installation, `gitpush` command is not recognized.

**Solutions**:

1. **Check PATH**:
```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "PATH OK" || echo "PATH missing"
```

2. **Add to PATH manually**:
```bash
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

3. **Verify installation**:
```bash
ls -la ~/.local/bin/gitpush
ls -la ~/.gitpush/
```

4. **Reinstall if needed**:
```bash
rm -rf ~/.gitpush ~/.local/bin/gitpush
curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash
```

### Permission denied

**Problem**: Permission errors when running gitpush.

**Solutions**:

1. **Fix script permissions**:
```bash
chmod +x ~/.gitpush/gitpush.sh
chmod +x ~/.gitpush/lib/**/*.sh
```

2. **Check directory permissions**:
```bash
ls -la ~/.gitpush/
ls -la ~/.local/bin/
```

3. **Recreate symlink**:
```bash
rm ~/.local/bin/gitpush
ln -sf ~/.gitpush/gitpush.sh ~/.local/bin/gitpush
```

### Missing dependencies

**Problem**: Required tools are not installed.

**Solutions**:

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install git curl jq
```

**macOS**:
```bash
brew install git curl jq
```

**Check GitHub CLI** (optional):
```bash
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

## AI Configuration Issues

### AI not working

**Problem**: AI features fail or return errors.

**Diagnosis**:
```bash
# Check configuration
cat ~/.gitpush/.env | grep -E "(AI_PROVIDER|API_KEY)"

# Test AI availability
gitpush --ai
```

**Solutions**:

1. **Verify API key**:
```bash
# For OpenAI
curl -H "Authorization: Bearer $OPENAI_API_KEY" https://api.openai.com/v1/models

# For Anthropic
curl -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/messages

# For Google
curl "https://generativelanguage.googleapis.com/v1/models?key=$GOOGLE_API_KEY"
```

2. **Check environment variables**:
```bash
echo "Provider: $AI_PROVIDER"
echo "OpenAI: $OPENAI_API_KEY"
echo "Anthropic: $ANTHROPIC_API_KEY"
echo "Google: $GOOGLE_API_KEY"
```

3. **Reconfigure AI**:
```bash
gitpush --ai --configure
```

### Environment file not loading

**Problem**: `.env` file settings are ignored.

**Solutions**:

1. **Check file location**:
```bash
ls -la ~/.gitpush/.env
ls -la ./.env
```

2. **Verify file format**:
```bash
cat ~/.gitpush/.env
# Should look like:
# AI_PROVIDER=openai
# OPENAI_API_KEY=sk-...
```

3. **Check file permissions**:
```bash
chmod 600 ~/.gitpush/.env
```

4. **Test manual loading**:
```bash
source ~/.gitpush/.env
echo $AI_PROVIDER
```

### Local AI (Ollama) issues

**Problem**: Local AI with Ollama not working.

**Solutions**:

1. **Check Ollama is running**:
```bash
curl http://localhost:11434/api/tags
```

2. **Install and start Ollama**:
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull codellama
ollama pull llama2

# Test model
ollama run codellama "Hello world"
```

3. **Configure gitpush for local**:
```bash
echo "AI_PROVIDER=local" >> ~/.gitpush/.env
```

## Git and GitHub Issues

### GitHub CLI authentication

**Problem**: GitHub features not working.

**Solutions**:

1. **Check authentication**:
```bash
gh auth status
```

2. **Login to GitHub**:
```bash
gh auth login
```

3. **Set up token manually**:
```bash
gh auth login --with-token < your_token_file
```

### Repository not found

**Problem**: gitpush can't detect Git repository.

**Solutions**:

1. **Verify Git repository**:
```bash
git status
git remote -v
```

2. **Initialize repository if needed**:
```bash
git init
git remote add origin https://github.com/user/repo.git
```

3. **Check permissions**:
```bash
ls -la .git/
```

### Branch issues

**Problem**: Problems with branch detection or switching.

**Solutions**:

1. **Check current branch**:
```bash
git branch
git status
```

2. **Fix detached HEAD**:
```bash
git checkout main
# or
git checkout -b new-branch
```

3. **Clean up branches**:
```bash
git branch -D broken-branch
git fetch --prune
```

## Performance Issues

### Slow startup

**Problem**: gitpush takes a long time to start.

**Solutions**:

1. **Check system resources**:
```bash
free -h
df -h
```

2. **Optimize stats file**:
```bash
# Backup and recreate stats
cp ~/.gitpush/stats.json ~/.gitpush/stats.json.bak
echo '{"total_commits": 0, "daily_stats": {}}' > ~/.gitpush/stats.json
```

3. **Disable plugins temporarily**:
```bash
mv ~/.gitpush/plugins ~/.gitpush/plugins.disabled
```

### Large repository performance

**Problem**: gitpush is slow in large repositories.

**Solutions**:

1. **Use shallow operations**:
```bash
git config --global fetch.prune true
git config --global fetch.prunetags true
```

2. **Optimize Git configuration**:
```bash
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
```

3. **Clean repository**:
```bash
git gc --aggressive
git repack -Ad
```

## Common Errors

### "jq: command not found"

**Problem**: JSON processor is missing.

**Solution**:
```bash
# Ubuntu/Debian
sudo apt install jq

# macOS
brew install jq

# Manual install
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x jq-linux64
sudo mv jq-linux64 /usr/local/bin/jq
```

### "curl: command not found"

**Problem**: HTTP client is missing.

**Solution**:
```bash
# Ubuntu/Debian
sudo apt install curl

# macOS (usually pre-installed)
xcode-select --install
```

### Stats file corruption

**Problem**: Analytics not working, JSON parse errors.

**Solutions**:

1. **Reset stats file**:
```bash
rm ~/.gitpush/stats.json
gitpush --stats  # Will recreate
```

2. **Manual recreation**:
```bash
cat > ~/.gitpush/stats.json << 'EOF'
{
  "total_commits": 0,
  "total_pushes": 0,
  "issues_created": 0,
  "issues_closed": 0,
  "ai_commits": 0,
  "tags_created": 0,
  "releases_created": 0,
  "daily_stats": {},
  "last_activity": null
}
EOF
```

### Plugin errors

**Problem**: Plugins causing crashes or errors.

**Solutions**:

1. **Disable all plugins**:
```bash
mv ~/.gitpush/plugins ~/.gitpush/plugins.disabled
```

2. **Check plugin logs**:
```bash
gitpush --plugins list
gitpush --plugins status
```

3. **Reinstall plugin system**:
```bash
rm -rf ~/.gitpush/plugins
mkdir ~/.gitpush/plugins
echo '{"installed": [], "enabled": []}' > ~/.gitpush/plugins/manifest.json
```

## Debug Mode

Enable debug output for troubleshooting:

```bash
# Set debug mode
export GITPUSH_DEBUG=1

# Run with verbose output
bash -x ~/.gitpush/gitpush.sh

# Check logs
tail -f ~/.gitpush/debug.log
```

## Getting Help

If none of these solutions work:

1. **Check existing issues**: [GitHub Issues](https://github.com/Karlblock/gitpush/issues)
2. **Create a bug report** with:
   - Operating system and version
   - Shell and version (`echo $SHELL; $SHELL --version`)
   - gitpush version (`gitpush --version`)
   - Error messages and logs
   - Steps to reproduce

3. **Join discussions**: [GitHub Discussions](https://github.com/Karlblock/gitpush/discussions)

4. **Contact support**: [support@gitpush.dev](mailto:support@gitpush.dev)

## System Information

Gather system information for bug reports:

```bash
#!/bin/bash
echo "=== System Information ==="
echo "OS: $(uname -a)"
echo "Shell: $SHELL ($($SHELL --version | head -1))"
echo "Git: $(git --version)"
echo "Gitpush: $(gitpush --version 2>/dev/null || echo 'Not installed')"
echo "Node: $(node --version 2>/dev/null || echo 'Not installed')"
echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
echo ""
echo "=== Dependencies ==="
command -v git && echo "✓ Git installed" || echo "✗ Git missing"
command -v curl && echo "✓ curl installed" || echo "✗ curl missing"
command -v jq && echo "✓ jq installed" || echo "✗ jq missing"
command -v gh && echo "✓ GitHub CLI installed" || echo "⚠ GitHub CLI missing (optional)"
echo ""
echo "=== Configuration ==="
echo "PATH includes ~/.local/bin: $(echo $PATH | grep -q ~/.local/bin && echo 'Yes' || echo 'No')"
echo "Gitpush directory: $(ls -ld ~/.gitpush 2>/dev/null || echo 'Not found')"
echo "Executable: $(ls -l ~/.local/bin/gitpush 2>/dev/null || echo 'Not found')"
```

Save this as `debug_info.sh`, run it, and include the output in bug reports.