#!/bin/bash

# Emoji Prefix Plugin for Gitpush
# Automatically adds emoji to commit messages based on type

# Register hooks
emoji_prefix_register_hooks() {
  register_hook "pre-commit" "emoji_prefix_add_emoji"
}

# Add emoji to commit message
emoji_prefix_add_emoji() {
  local message="$1"
  
  # Check if emoji already present
  if [[ "$message" =~ ^[[:space:]]*[🎨🐛✨📚♻️🧪🔧💄⚡️🔥📝🚀🏷️] ]]; then
    echo "$message"
    return
  fi
  
  # Detect commit type
  local emoji=""
  case "$message" in
    feat:*|feature:*)
      emoji="✨ "
      ;;
    fix:*|bugfix:*)
      emoji="🐛 "
      ;;
    docs:*|documentation:*)
      emoji="📚 "
      ;;
    style:*|formatting:*)
      emoji="🎨 "
      ;;
    refactor:*)
      emoji="♻️ "
      ;;
    test:*|tests:*)
      emoji="🧪 "
      ;;
    chore:*)
      emoji="🔧 "
      ;;
    perf:*|performance:*)
      emoji="⚡ "
      ;;
    hotfix:*)
      emoji="🔥 "
      ;;
    release:*)
      emoji="🚀 "
      ;;
    *)
      # Default emoji for general commits
      emoji="📝 "
      ;;
  esac
  
  # Return message with emoji
  echo "${emoji}${message}"
}

# Plugin info
emoji_prefix_info() {
  echo "Emoji Prefix Plugin v1.0.0"
  echo "Automatically adds contextual emojis to your commits!"
}

# Export functions
export -f emoji_prefix_register_hooks
export -f emoji_prefix_add_emoji
export -f emoji_prefix_info