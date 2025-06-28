#!/bin/bash

# Quick and dirty release script
# TODO: automate this properly

VERSION="v1.0.0-beta"
RELEASE_TITLE="gitpush $VERSION"

echo "Creating gitpush $VERSION release..."

# Create tag
echo "Creating tag..."
# NOTE: should probably check if tag already exists
git tag -a $VERSION -m "$RELEASE_TITLE

Beta release:
- AI integration (OpenAI, Anthropic, etc)
- Basic analytics
- GUI (experimental)
- Plugin system
- Tests

See CHANGELOG.md for details"

# Push tag
echo "Pushing tag to origin..."
git push origin $VERSION

# Create GitHub release
echo "Creating GitHub release..."
gh release create $VERSION \
  --title "$RELEASE_TITLE" \
  --notes-file RELEASE_NOTES_v1.0.0-beta_CLEAN.md \
  --prerelease

echo "Release $VERSION created successfully!"
echo "View at: https://github.com/Karlblock/gitpush/releases/tag/$VERSION"