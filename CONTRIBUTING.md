# Contributing to gitpush

Thank you for your interest in contributing to gitpush! We're building the future of Git workflow automation together.

## Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inclusive experience for everyone, regardless of:
- Background and identity
- Level of experience
- Nationality or personal appearance
- Religion or political affiliation

### Expected Behavior
- **Be respectful**: Treat everyone with kindness and respect
- **Be constructive**: Provide helpful feedback and suggestions
- **Be collaborative**: Work together towards common goals
- **Be patient**: Help newcomers learn and grow

### Unacceptable Behavior
- Harassment, discrimination, or intimidation
- Personal attacks or inflammatory comments
- Publishing private information without permission
- Any conduct that would be inappropriate in a professional setting

## Getting Started

### Prerequisites
- **Git** (v2.0+)
- **Bash** shell knowledge
- **GitHub** account
- **jq** for JSON processing
- Basic understanding of shell scripting

### Development Setup

1. **Fork and clone** the repository:
```bash
git clone https://github.com/YOUR_USERNAME/gitpush.git
cd gitpush
```

2. **Install development dependencies**:
```bash
./install.sh --dev
```

3. **Run the test suite**:
```bash
./tests/run_tests.sh
```

4. **Create a feature branch**:
```bash
git checkout -b feature/amazing-new-feature
```

## How to Contribute

### 🐛 Bug Reports

When reporting bugs, please include:

1. **Clear description** of the issue
2. **Steps to reproduce** the problem
3. **Expected vs actual behavior**
4. **Environment details**:
   - OS and version
   - Shell (bash, zsh, etc.)
   - gitpush version
   - Git version

**Template**:
```markdown
## Bug Description
A clear description of what the bug is.

## Steps to Reproduce
1. Run `gitpush --command`
2. Select option X
3. See error

## Expected Behavior
What should have happened.

## Actual Behavior
What actually happened.

## Environment
- OS: Ubuntu 22.04
- Shell: bash 5.1.16
- gitpush: v1.0.0-beta
- Git: 2.34.1
```

### 🌟 Feature Requests

Before suggesting new features:

1. **Check existing issues** to avoid duplicates
2. **Explain the use case** and why it's needed
3. **Describe the proposed solution**
4. **Consider implementation complexity**

**Template**:
```markdown
## Feature Summary
Brief description of the feature.

## Problem Statement
What problem does this solve?

## Proposed Solution
How should this work?

## Alternatives Considered
What other solutions did you consider?

## Additional Context
Screenshots, mockups, related issues, etc.
```

### 🔧 Code Contributions

#### Pull Request Process

1. **Create an issue first** (for non-trivial changes)
2. **Fork and branch** from `main`
3. **Write code** following our standards
4. **Add tests** for new functionality
5. **Update documentation** as needed
6. **Submit pull request** with clear description

#### Code Standards

**Shell Scripting Guidelines**:
```bash
#!/bin/bash

# Use strict mode
set -euo pipefail

# Function naming: snake_case
my_function() {
    local param="$1"
    echo "Processing: $param"
}

# Variable naming: lowercase with underscores
local_var="value"
GLOBAL_CONSTANT="VALUE"

# Comments for complex logic
# This function handles user input validation
validate_input() {
    # Implementation here
}

# Error handling
if ! command -v git &>/dev/null; then
    echo "Error: Git is required" >&2
    exit 1
fi
```

**Best Practices**:
- Use `shellcheck` for linting
- Quote variables to prevent word splitting
- Use `[[ ]]` instead of `[ ]` for conditionals
- Prefer functions over inline code
- Add error handling for all external commands
- Use meaningful variable and function names

#### Testing Requirements

- **Unit tests** for new functions
- **Integration tests** for workflows
- **Test coverage** should not decrease
- **All tests must pass** before merging

```bash
# Run specific test category
cd tests
./run_tests.sh basic
./run_tests.sh ai
./run_tests.sh integration

# Add new test
assert_equals "expected" "$(my_function)" "Test description"
```

#### Documentation Updates

When adding features:
- Update `README.md` if needed
- Add or update command documentation
- Include usage examples
- Update help text in the script

### 🔌 Plugin Development

gitpush supports plugins for extending functionality:

```bash
# Create plugin template
gitpush --plugins create my-plugin

# Plugin structure
plugins/my-plugin/
├── plugin.json         # Metadata
├── plugin.sh          # Main implementation
├── hooks/             # Git hooks (optional)
└── README.md          # Plugin documentation
```

See [Plugin Development Guide](docs/PLUGIN_DEVELOPMENT.md) for details.

### 📖 Documentation

Help improve our documentation:
- Fix typos and grammar
- Add examples and use cases
- Improve clarity and organization
- Translate to other languages

## Development Workflow

### Branch Naming Convention
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test improvements

### Commit Message Format
We follow [Conventional Commits](https://conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

**Types**:
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

**Examples**:
```
feat(ai): add support for Google Gemini API
fix(stats): resolve file corruption issue
docs(readme): update installation instructions
```

### Pull Request Guidelines

**Title**: Clear, descriptive summary
**Description**: Should include:
- What changes were made
- Why the changes were needed
- How to test the changes
- Related issues (use `fixes #123`)

**Template**:
```markdown
## Summary
Brief description of changes.

## Changes Made
- [ ] Added new feature X
- [ ] Fixed bug in component Y
- [ ] Updated documentation

## Testing
How to test these changes:
1. Run `gitpush --new-feature`
2. Verify output matches expected result

## Related Issues
Fixes #123
Related to #456
```

## Release Process

gitpush follows semantic versioning:
- **Major** (1.0.0): Breaking changes
- **Minor** (1.1.0): New features, backward compatible
- **Patch** (1.1.1): Bug fixes, backward compatible

### Release Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped in all files
- [ ] Tag created and pushed
- [ ] GitHub release created

## Community

### Getting Help
- 💬 [GitHub Discussions](https://github.com/Karlblock/gitpush/discussions)
- 🐛 [Issue Tracker](https://github.com/Karlblock/gitpush/issues)
- 📧 Email: [support@gitpush.dev](mailto:support@gitpush.dev)

### Recognition
Contributors are recognized in:
- `AUTHORS.md` file
- Release notes
- GitHub contributor graph
- Special mentions for significant contributions

## Areas for Contribution

We especially welcome help with:

### 🚀 High Priority
- **Bug fixes** and stability improvements
- **Test coverage** expansion
- **Documentation** improvements
- **Performance** optimizations

### 🌟 Medium Priority
- **New AI providers** integration
- **Plugin ecosystem** development
- **Multi-platform** support (Windows, macOS)
- **Accessibility** improvements

### 💡 Future Ideas
- **Mobile companion app**
- **Web dashboard**
- **VS Code extension** enhancements
- **Enterprise features**

## Questions?

Don't hesitate to ask! We're here to help:
- Open a [discussion](https://github.com/Karlblock/gitpush/discussions)
- Comment on relevant issues
- Reach out to maintainers

---

**Thank you for contributing to gitpush!** 🚀

*Together, we're making Git workflows smarter and more enjoyable for developers worldwide.*