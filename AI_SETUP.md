# 🤖 Gitpush AI Setup Guide

## 🚀 Quick Start

### 1. Configuration OpenAI (Recommandé)
```bash
# Obtenir une clé API sur https://platform.openai.com
export OPENAI_API_KEY="sk-..."
export AI_PROVIDER="openai"

# Ajouter à ~/.bashrc pour persistance
echo 'export OPENAI_API_KEY="sk-..."' >> ~/.bashrc
echo 'export AI_PROVIDER="openai"' >> ~/.bashrc
```

### 2. Configuration Anthropic (Claude)
```bash
# Obtenir une clé sur https://console.anthropic.com
export ANTHROPIC_API_KEY="sk-ant-..."
export AI_PROVIDER="anthropic"
```

### 3. Configuration Local (Gratuit)
```bash
# Installer Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Télécharger un modèle
ollama pull codellama

# Configurer gitpush
export AI_PROVIDER="local"
```

---

## 🎯 Utilisation

### Génération de commits
```bash
# Mode interactif
gitpush --ai

# Génération directe
gitpush --ai-commit

# Workflow complet avec AI
gitpush --ai-commit --yes
```

### Exemples de résultats
```
# Avant
git commit -m "updated auth"

# Après avec AI
git commit -m "feat(auth): implement JWT refresh token rotation with Redis cache"
```

---

## 🔧 Features AI disponibles

### v0.5.0 (Current)
- ✅ Génération de messages de commit
- ✅ Analyse pre-commit basique
- ✅ Suggestions de noms de branches
- ✅ Support multi-providers

### v0.5.1 (Coming)
- 🔄 Review de code complète
- 🔄 Résolution de conflits
- 🔄 Documentation auto
- 🔄 Tests génération

---

## 💰 Coûts estimés

### OpenAI (GPT-4)
- ~$0.001 par commit message
- ~$0.10 pour 100 commits
- Model: gpt-4-turbo

### Anthropic (Claude)
- ~$0.0008 par commit
- ~$0.08 pour 100 commits
- Model: claude-3-haiku

### Local (Ollama)
- **GRATUIT** 🎉
- Performance variable
- Privacy maximale

---

## 🛡️ Sécurité

### Best Practices
1. **Ne jamais commiter les API keys**
2. Utiliser des variables d'environnement
3. Rotation régulière des clés
4. Mode local pour code sensible

### Configuration sécurisée
```bash
# Utiliser un fichier .env (non commité)
cat > ~/.gitpush/.env << EOF
OPENAI_API_KEY=sk-...
AI_PROVIDER=openai
EOF

# Charger au démarrage
echo 'source ~/.gitpush/.env' >> ~/.bashrc
```

---

## 🐛 Troubleshooting

### "AI non configuré"
```bash
# Vérifier la config
echo $AI_PROVIDER
echo $OPENAI_API_KEY | cut -c1-10

# Recharger bashrc
source ~/.bashrc
```

### "Erreur API"
- Vérifier la validité de la clé
- Vérifier les quotas/limites
- Essayer un autre provider

### Performance lente
- Utiliser un modèle plus petit
- Passer en mode local
- Vérifier la connexion

---

## 📚 Resources

- [OpenAI API Docs](https://platform.openai.com/docs)
- [Anthropic Claude](https://docs.anthropic.com)
- [Ollama Models](https://ollama.ai/library)
- [Gitpush AI Roadmap](ROADMAP.md#v050---ai-powered-assistant)

---

💡 **Pro Tip**: Commencez avec le mode local (Ollama) pour tester gratuitement !