# Gitpush VS Code Extension

> Bring AI-powered Git workflows directly into your VS Code editor

## Features

- **🤖 Smart Commits**: AI-generated commit messages with one click
- **📝 Issue Management**: Create GitHub issues directly from VS Code
- **📊 Analytics Dashboard**: View your Git stats and productivity metrics
- **🔍 AI Code Review**: Get intelligent feedback before committing
- **⚙️ Easy Configuration**: Set up AI providers without leaving VS Code

## Installation

1. Install from VS Code Marketplace (coming soon)
2. Or install gitpush CLI first: `curl -sSL https://gitpush.dev/install.sh | bash`
3. Configure your AI provider in VS Code settings

## Quick Start

1. Open any Git repository in VS Code
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
3. Type "Gitpush" to see available commands
4. Or click the Gitpush icon in the status bar

## Commands

| Command | Shortcut | Description |
|---------|----------|-------------|
| `Gitpush: Smart Commit` | `Ctrl+Shift+G C` | AI-powered commit with auto-generated message |
| `Gitpush: Create Issue` | - | Create GitHub issue from current context |
| `Gitpush: Show Stats` | - | Open analytics dashboard |
| `Gitpush: AI Code Review` | - | Get AI feedback on your changes |

## Configuration

```json
{
  "gitpush.aiProvider": "openai",
  "gitpush.autoSuggestCommitMessage": true,
  "gitpush.showStatsInSidebar": true
}
```

## Development Roadmap

- [ ] **v0.1.0**: Basic commands (Smart Commit, Issue Creation)
- [ ] **v0.2.0**: Analytics webview
- [ ] **v0.3.0**: Sidebar integration
- [ ] **v0.4.0**: Diff highlighting with AI suggestions
- [ ] **v0.5.0**: Team collaboration features

## Why VS Code Extension?

- **Seamless workflow**: No context switching
- **Visual feedback**: Rich UI for stats and suggestions  
- **Easy adoption**: Discover gitpush while coding
- **Team onboarding**: Share extension in team workspaces