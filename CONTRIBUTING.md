# Contributing to gitpush

Thank you for your interest in contributing to gitpush! 🎉

## Quick Start

1. **Fork the repository**
2. **Clone your fork:**
   ```bash
   git clone https://github.com/yourusername/gitpush.git
   cd gitpush
   ```
3. **Install gitpush:**
   ```bash
   ./install.sh
   ```
4. **Run tests:**
   ```bash
   ./tests/run_tests.sh
   ```

## Development Guidelines

### Code Style
- Use clear, descriptive variable names
- Add comments for complex logic
- Follow existing bash scripting conventions
- Test your changes thoroughly

### Commit Messages
Use conventional commit format:
```
feat: add new feature
fix: resolve bug
docs: update documentation
test: add or update tests
```

### Testing
- All new features must include tests
- Run the full test suite before submitting
- Ensure tests pass on different platforms

## Areas for Contribution

### 🐛 Bug Fixes
- Check [open issues](https://github.com/Karlblock/gitpush/issues)
- Reproduce the issue locally
- Write a test that fails
- Fix the issue
- Verify the test passes

### ✨ New Features
- Discuss major features in issues first
- Keep features focused and simple
- Update documentation
- Add comprehensive tests

### 📚 Documentation
- Improve README clarity
- Add examples and use cases
- Fix typos and grammar
- Translate to other languages

### 🔌 Plugins
- Create new plugins in `plugins/` directory
- Follow the plugin API structure
- Include plugin documentation
- Add installation instructions

## Submitting Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/awesome-feature
   ```

2. **Make your changes:**
   - Write code
   - Add tests
   - Update docs

3. **Test everything:**
   ```bash
   ./tests/run_tests.sh
   gitpush --simulate  # Test the main workflow
   ```

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add awesome feature"
   ```

5. **Push and create PR:**
   ```bash
   git push origin feature/awesome-feature
   ```
   Then create a Pull Request on GitHub.

## Code of Conduct

- Be respectful and inclusive
- Help others learn and grow
- Focus on constructive feedback
- Keep discussions professional

## Need Help?

- 💬 [Start a discussion](https://github.com/Karlblock/gitpush/discussions)
- 🐛 [Report a bug](https://github.com/Karlblock/gitpush/issues)
- 📧 Email: support@gitpush.dev

## Recognition

Contributors are recognized in:
- Release notes
- Project documentation
- Special contributor badges

Thank you for making gitpush better! 🚀