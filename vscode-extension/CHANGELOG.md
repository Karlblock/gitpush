# Gitpush VS Code Extension Changelog

## [1.1.0] - 2025-06-28

### Added
- **Smart Commit Integration**: AI-powered commit messages directly in VS Code
- **Source Control Menu**: Quick access via Git SCM panel
- **Status Bar Integration**: One-click access to Gitpush features
- **AI Configuration**: Set up providers without leaving VS Code
- **Auto-detection**: Finds gitpush CLI in multiple locations
- **Custom Path Support**: Override CLI location in settings

### Features
- AI-powered commit message generation
- GitHub issue creation workflow
- Analytics dashboard integration
- AI code review capabilities
- Easy AI provider configuration

### Developer Experience
- TypeScript 5.0+ support
- Modern VS Code API compatibility (1.80+)
- Comprehensive error handling
- Progress indicators for long operations
- Keyboard shortcuts (Ctrl+Shift+G C)

### Configuration Options
- `gitpush.aiProvider`: Choose AI provider (openai, anthropic, google, local)
- `gitpush.autoSuggestCommitMessage`: Auto-suggest commits (default: true)
- `gitpush.enableStatusBar`: Show status bar item (default: true)
- `gitpush.gitpushPath`: Custom CLI path (auto-detected by default)

### Requirements
- VS Code 1.80.0 or higher
- Gitpush CLI v1.0.0+ installed
- Git repository (for most features)

### Installation
Available on VS Code Marketplace as "Gitpush - AI-Powered Git Workflow"

---

*For full gitpush CLI changelog, see [main repository](https://github.com/karlblock/gitpush)*
