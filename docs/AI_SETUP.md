# AI Setup Guide

## Quick Start

1. Copy the example environment file:
```bash
cp .env.example .env
```

2. Edit `.env` and add your API key:
```bash
# For OpenAI
AI_PROVIDER=openai
OPENAI_API_KEY=sk-your-key-here

# For Anthropic
AI_PROVIDER=anthropic
ANTHROPIC_API_KEY=your-key-here

# For Google
AI_PROVIDER=google
GOOGLE_API_KEY=your-key-here

# For local (Ollama)
AI_PROVIDER=local
# Make sure Ollama is running
```

3. Test AI is working:
```bash
gitpush --ai-commit
```

## Environment File Locations

Gitpush looks for `.env` files in this order:
1. `./.env` (current directory)
2. `~/.gitpush/.env` (user config directory)

## Getting API Keys

### OpenAI
1. Go to https://platform.openai.com/api-keys
2. Create new secret key
3. Copy to your `.env` file

### Anthropic
1. Go to https://console.anthropic.com/
2. Navigate to API keys
3. Create and copy key

### Google Gemini
1. Go to https://makersuite.google.com/app/apikey
2. Create API key
3. Copy to your `.env` file

### Local (Ollama)
1. Install Ollama: https://ollama.ai
2. Pull a model: `ollama pull codellama`
3. No API key needed

## Troubleshooting

If AI features aren't working:

1. Check your `.env` file exists and has correct permissions
2. Verify API key is valid
3. Check environment variables are loaded:
```bash
echo $OPENAI_API_KEY  # Should show your key (or part of it)
```

4. Test AI directly:
```bash
gitpush --ai
```

## Security Notes

- Never commit your `.env` file (it's in `.gitignore`)
- Use environment-specific files: `.env.local`, `.env.production`
- Consider using a secrets manager for production