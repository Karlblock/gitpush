# gitpush

> Intelligent Git workflow automation with AI-powered features

[![Version](https://img.shields.io/badge/version-1.0.0--beta-blue.svg)](https://github.com/Karlblock/gitpush/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-orange.svg)](https://www.gnu.org/software/bash/)
[![Tests](https://img.shields.io/badge/tests-94%25-brightgreen.svg)](#testing)

```
          _ __                   __  
   ____ _(_) /_____  __  _______/ /_ 
  / __ `/ / __/ __ \/ / / / ___/ __ \
 / /_/ / / /_/ /_/ / /_/ (__  ) / / /
 \__, /_/\__/ .___/\__,_/____/_/ /_/ 
/____/     /_/                       
```

**gitpush** transforms tedious Git workflows into intelligent, automated operations. From AI-generated commit messages to team collaboration features, it's the Git assistant you didn't know you needed.

## Why gitpush?

Stop typing the same Git commands over and over. gitpush handles the entire workflow intelligently:

```bash
# Before gitpush
git add .
git commit -m "fix stuff"  # What stuff?!
git pull --rebase
git push
# Did I forget something? 🤔

# With gitpush
gitpush
# AI analyzes changes, suggests commit message, handles everything
```

## Features

### 🤖 **AI-Powered**
- **Smart commit messages**: AI analyzes your changes and generates contextual commit messages
- **Code review**: Get intelligent feedback before committing
- **Conflict resolution**: AI-assisted merge conflict resolution
- **Multiple providers**: OpenAI, Anthropic, Google Gemini, Ollama (local)

### 📋 **Issue Management**
- Create and manage GitHub issues directly from CLI
- Auto-link commits to issues with keywords (`fixes #123`)
- Smart label suggestions and management
- Issue auto-closure on commit

### 👥 **Team Collaboration**
- Shared workflows and templates
- Team statistics and productivity metrics
- Automated reviewer assignment
- Standup report generation

### 🔌 **Extensible**
- Plugin system with hooks
- Custom workflow templates
- Community marketplace
- Easy plugin development

### 🖥️ **Modern Interface**
- Interactive CLI with smart defaults
- Desktop GUI (Electron-based)
- VS Code extension (coming soon)
- Real-time analytics dashboard

## Quick Start

### Installation

```bash
# One-line install
curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash

# Manual install
git clone https://github.com/Karlblock/gitpush.git
cd gitpush
./install.sh
```

### Basic Usage

```bash
# Interactive mode (recommended)
gitpush

# AI-powered commit
gitpush --ai-commit

# Quick workflow with message
gitpush -m "feat: add user authentication" --yes

# Manage issues
gitpush --issues

# Show analytics
gitpush --stats
```

### AI Configuration

1. Copy the example config:
```bash
cp ~/.gitpush/.env.example ~/.gitpush/.env
```

2. Add your API key:
```bash
# Edit ~/.gitpush/.env
AI_PROVIDER=openai
OPENAI_API_KEY=sk-your-key-here
```

3. Test it works:
```bash
gitpush --ai-commit
```

See [AI Setup Guide](docs/AI_SETUP.md) for detailed configuration.

## Commands

| Command | Description |
|---------|-------------|
| `gitpush` | Interactive Git workflow |
| `gitpush --ai` | AI assistant mode |
| `gitpush --ai-commit` | Generate commit with AI |
| `gitpush --issues` | GitHub issues management |
| `gitpush --stats` | View analytics dashboard |
| `gitpush --team` | Team collaboration features |
| `gitpush --plugins` | Plugin management |
| `gitpush --gui` | Launch desktop application |
| `gitpush --simulate` | Preview actions without executing |
| `gitpush --test` | Run test suite |

## Architecture

```
gitpush/
├── gitpush.sh           # Main CLI script
├── lib/
│   ├── ai/              # AI providers and features
│   ├── analytics/       # Statistics and metrics
│   ├── team/            # Collaboration features
│   └── plugins/         # Extension system
├── gui/                 # Electron desktop app
├── vscode-extension/    # VS Code integration
├── tests/               # Comprehensive test suite
└── docs/                # Documentation
```

## Examples

### Smart Commit Workflow
```bash
$ gitpush
Current branch: feature/user-auth
Repository: my-awesome-app

🤖 AI analyzing your changes...
📝 Suggested commit: "feat(auth): implement JWT-based user authentication

- Add login/logout endpoints
- Implement token validation middleware  
- Add user session management"

✅ Use this message? (Y/n): y
🔄 Pull before push? (y/N): y
🏷️ Create tag? (y/N): n
🚀 Push to GitHub? (Y/n): y

✅ All done! View at: https://github.com/user/repo/commit/abc123
```

### Issue Management
```bash
$ gitpush --issues
📋 Open Issues:
#42 Add dark mode support [enhancement]
#41 Fix mobile responsive layout [bug]

1) 📋 List issues    3) 🔒 Close issue
2) ➕ Create issue   4) 🏷️ Manage labels

Your choice: 2
Title: Implement user avatars
Description: Add profile pictures for user accounts
Labels: enhancement, ui

✅ Issue #43 created: https://github.com/user/repo/issues/43
```

## Configuration

### Environment Variables
```bash
# AI Configuration
AI_PROVIDER=openai              # openai, anthropic, google, local
OPENAI_API_KEY=sk-...           # Your API key
ANTHROPIC_API_KEY=...           # Alternative provider
GOOGLE_API_KEY=...              # Google Gemini

# GitHub (optional, uses system gh config)
GITHUB_TOKEN=ghp_...            # Personal access token

# Team Features
TEAM_ID=my-team                 # Team identifier
SLACK_WEBHOOK_URL=https://...   # Notifications
```

### Workflow Customization
```bash
# Create custom workflow template
gitpush --team workflows create

# Configure git hooks
gitpush --plugins install git-hooks

# Set up analytics
gitpush --stats configure
```

## Advanced Features

### Plugin Development
```bash
# Create a new plugin
gitpush --plugins create my-plugin

# Plugin structure
plugins/my-plugin/
├── plugin.json          # Metadata
├── plugin.sh           # Implementation
└── hooks/              # Git hooks
```

### Team Analytics
- **Productivity metrics**: Commit frequency, code quality scores
- **Team insights**: Top contributors, active repositories
- **Workflow optimization**: Bottleneck identification
- **Custom reports**: Weekly/monthly summaries

### AI Code Review
- **Security scanning**: Detect potential vulnerabilities
- **Best practices**: Code style and convention checks
- **Performance hints**: Optimization suggestions
- **Learning mode**: Adapts to your coding patterns

## Testing

gitpush includes a comprehensive test suite:

```bash
# Run all tests
gitpush --test

# Manual testing
cd tests && ./run_tests.sh

# Current status: 33/35 tests passing (94%)
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup
```bash
git clone https://github.com/Karlblock/gitpush.git
cd gitpush
./install.sh --dev
./tests/run_tests.sh
```

### Areas for Contribution
- 🐛 Bug fixes and improvements
- 🌟 New AI providers
- 🔌 Plugin development
- 📖 Documentation improvements
- 🧪 Test coverage expansion

## Roadmap

- **v1.0.0** (July 2025): Stable release
- **v1.1.0** (August 2025): VS Code extension
- **v1.2.0** (September 2025): Multi-platform support (GitLab, Bitbucket)
- **v2.0.0** (Q4 2025): Enterprise features, SaaS offering

See [ROADMAP.md](ROADMAP.md) for detailed plans.

## Support

- 📖 [Documentation](docs/)
- 🐛 [Bug Reports](https://github.com/Karlblock/gitpush/issues)
- 💬 [Discussions](https://github.com/Karlblock/gitpush/discussions)
- 📧 [Email Support](mailto:support@gitpush.dev)

## License

MIT © [Karl Block](https://github.com/Karlblock)

---

**Made with ❤️ by developers, for developers**

*Transform your Git workflow today and never look back.*