# gitpush

> Smart Git workflow automation for developers

[![Version](https://img.shields.io/badge/version-1.2.0-blue.svg)](https://github.com/Karlblock/gitpush/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

```
          _ __                   __  
   ____ _(_) /_____  __  _______/ /_ 
  / __ `/ / __/ __ \/ / / / ___/ __ \
 / /_/ / / /_/ /_/ / /_/ (__  ) / / / 
 \__, /_/\__/ .___/\__,_/____/_/ /_/  
/____/     /_/                       
```

**gitpush** streamlines your Git workflow with intelligent automation, AI-powered features, and team collaboration tools.

## Why gitpush?

Transform your Git workflow from this:
```bash
git add .
git commit -m "fix stuff"  # What stuff?!
git pull --rebase
git push
```

To this:
```bash
gitpush
# Smart workflow with AI suggestions, issue management, and more
```

## Features

### Smart Workflows
- Interactive Git operations with safety checks
- Automatic branch protection for main/master
- Smart tag generation with semantic versioning
- GitHub release automation

### AI Integration
- AI-powered commit message generation
- Code review and security analysis
- Support for OpenAI, Anthropic, Google, and local models
- Intelligent conflict resolution

### Issue Management
- Create and manage GitHub issues
- Auto-link commits to issues
- Smart label management
- Issue auto-closure via commit keywords

### Team Features
- Team statistics and analytics
- Shared workflows and templates
- Productivity tracking and insights

### Extensions
- VS Code extension for seamless integration
- Plugin system for custom workflows
- Multiple installation methods

## Installation

### Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash
```

### Package Managers
```bash
# Homebrew (macOS/Linux)
brew tap karlblock/gitpush && brew install gitpush

# npm (Node.js)
npm install -g gitpush-cli

# Manual
git clone https://github.com/Karlblock/gitpush.git
cd gitpush && ./install.sh
```

## Quick Start

1. **Basic workflow:**
   ```bash
   gitpush
   ```

2. **With AI-generated commit:**
   ```bash
   gitpush --ai-commit
   ```

3. **Manage GitHub issues:**
   ```bash
   gitpush --issues
   ```

4. **View team analytics:**
   ```bash
   gitpush --stats
   ```

## Configuration

### AI Setup
1. Copy example config:
   ```bash
   cp ~/.gitpush/.env.example ~/.gitpush/.env
   ```

2. Add your API key:
   ```bash
   # Edit ~/.gitpush/.env
   AI_PROVIDER=openai
   OPENAI_API_KEY=sk-your-key-here
   ```

### GitHub Integration
Requires [GitHub CLI](https://cli.github.com/) for issue management and releases.

## Commands

| Command | Description |
|---------|-------------|
| `gitpush` | Interactive Git workflow |
| `gitpush --ai-commit` | AI-generated commit message |
| `gitpush --issues` | GitHub issues management |
| `gitpush --stats` | Team analytics |
| `gitpush --simulate` | Preview actions without executing |
| `gitpush --help` | Show all options |

## VS Code Extension

Install "Gitpush" from VS Code marketplace for:
- One-click AI commits
- Source control integration
- Issue management
- Team statistics

## Examples

### Smart Commit Workflow
```bash
$ gitpush
Current branch: feature/auth
Repository: my-app

AI analyzing changes...
Suggested: "feat(auth): implement JWT authentication with user sessions"

Use this message? (Y/n): y
Pull before push? (y/N): y
Create tag? (y/N): n
Push to GitHub? (Y/n): y

Done! View at: https://github.com/user/repo/commit/abc123
```

### Issue Management
```bash
$ gitpush --issues
Open Issues:
#42 Add dark mode support [enhancement]
#41 Fix mobile layout [bug]

1) List issues    3) Close issue
2) Create issue   4) Manage labels

Your choice: 2
Title: Add user avatars
Labels: enhancement, ui
Issue #43 created!
```

## Documentation

- [Installation Guide](docs/INSTALLATION.md) - Detailed setup instructions
- [Contributing](CONTRIBUTING.md) - How to contribute
- [Changelog](CHANGELOG.md) - Version history
- [Roadmap](ROADMAP.md) - Future plans

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Support

- [Issues](https://github.com/Karlblock/gitpush/issues)
- [Discussions](https://github.com/Karlblock/gitpush/discussions)
- Email: support@gitpush.dev

## License

MIT © [Karl Block](https://github.com/Karlblock)

---

**Made by developers, for developers**