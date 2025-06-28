# 🤝 Contributing to Gitpush

Merci de vouloir contribuer à Gitpush ! Ensemble, nous allons révolutionner l'expérience Git. 🚀

---

## 🎯 Code of Conduct

### Be Nice 
- Respecter tout le monde
- Feedback constructif uniquement
- Célébrer les succès ensemble

---

## 🚀 Quick Start

```bash
# 1. Fork le repo
git clone https://github.com/YOUR_USERNAME/gitpush.git
cd gitpush

# 2. Créer une branche
./gitpush.sh --new-branch feat/amazing-feature

# 3. Coder avec passion
vim gitpush.sh

# 4. Tester localement
./gitpush.sh --simulate

# 5. Commit avec gitpush !
./gitpush.sh -m "feat: add amazing feature"

# 6. Push et créer une PR
```

---

## 🏗️ Architecture

```
gitpush/
├── gitpush.sh          # Script principal
├── lib/                # Futures librairies
│   ├── ai/            # Intégration IA
│   ├── ui/            # Composants UI
│   └── utils/         # Utilitaires
├── tests/             # Tests unitaires
├── docs/              # Documentation
└── examples/          # Exemples d'usage
```

---

## 🎨 Coding Standards

### Style Bash
```bash
# ✅ BON
function create_issue() {
  local title="$1"
  local body="$2"
  
  if [[ -z "$title" ]]; then
    echo -e "${RED}Error:${NC} Title required"
    return 1
  fi
}

# ❌ MAUVAIS
function createIssue {
  title=$1
  if [ "$title" = "" ]; then echo "Error"; fi
}
```

### Conventions
- Functions: `snake_case`
- Variables: `UPPER_CASE` pour globales, `lower_case` pour locales
- Indentation: 2 espaces
- Toujours utiliser `[[` au lieu de `[`
- Citations: guillemets pour les variables

---

## 🧪 Testing

### Ajouter des tests
```bash
# tests/test_issues.sh
test_create_issue() {
  result=$(./gitpush.sh --issues create --simulate)
  assert_contains "$result" "Issue créée"
}
```

### Lancer les tests
```bash
./tests/run_all.sh
```

---

## 📝 Types de Contributions

### 🐛 Bug Reports
```markdown
**Description**: Message d'erreur lors de...
**Étapes**: 
1. Lancer `gitpush --issues`
2. Choisir option 2
**Attendu**: Création d'issue
**Actuel**: Erreur ligne 234
**Environnement**: Ubuntu 22.04, Bash 5.1
```

### ✨ New Features
```markdown
**Feature**: Support des templates d'issues
**Motivation**: Gagner du temps avec des templates
**Proposition**:
- Ajouter `gitpush --template bug`
- Stocker dans `.gitpush/templates/`
**Mockup**: [voir image]
```

### 📚 Documentation
- Traduire en d'autres langues
- Ajouter des exemples
- Améliorer les explications
- Créer des tutoriels vidéo

### 🎨 Design
- Améliorer l'UI terminal
- Créer des logos/bannières
- Designer le site web
- Mockups pour GUI

---

## 🔄 Pull Request Process

### 1. Avant de commencer
- [ ] Issue existe ou créer une
- [ ] Assigner l'issue à toi
- [ ] Discuter si gros changement

### 2. Development
- [ ] Branch depuis `dev` (pas `main`)
- [ ] Commits atomiques
- [ ] Messages conventionnels
- [ ] Tests ajoutés/mis à jour

### 3. PR Checklist
```markdown
## Description
Résoudre #123 - Ajouter support des templates

## Changements
- Ajout fonction `load_template()`
- Nouveau flag `--template`
- Tests unitaires

## Tests
- [ ] Tests passent localement
- [ ] Testé manuellement
- [ ] Documentation mise à jour

## Screenshots
[Si applicable]
```

### 4. Review Process
1. CI/CD automatique vérifie le code
2. Review par un maintainer
3. Modifications si nécessaire
4. Merge par un maintainer

---

## 🏆 Recognition

### Contributors Wall
Tous les contributeurs sont listés dans:
- README.md (section Contributors)
- CONTRIBUTORS.md (détails)
- Site web (hall of fame)

### Badges
- 🥇 **Core Contributor**: 10+ PRs mergées
- 🌟 **Star Contributor**: Feature majeure
- 🐛 **Bug Hunter**: 5+ bugs fixés
- 📚 **Doc Hero**: Documentation majeure
- 🌍 **Translation Hero**: Traduction complète

---

## 💬 Communication

### Discord
- `#dev-chat`: Discussion générale
- `#help`: Aide pour contribuer
- `#showcase`: Montrer ton travail
- `#ideas`: Proposer des features

### GitHub
- Issues: Bugs et features
- Discussions: Questions et idées
- PR: Code contributions

---

## 🎁 Rewards

### Swag Gitpush
- 5 PRs = Stickers
- 10 PRs = T-shirt
- 20 PRs = Hoodie
- 50 PRs = Contributeur VIP

### Opportunités
- Devenir maintainer
- Accès early-access
- Influence sur la roadmap
- Mention dans les releases

---

## 🚀 First Time?

### Good First Issues
```bash
# Trouver une issue facile
git clone https://github.com/karlblock/gitpush
cd gitpush
gh issue list --label "good-first-issue"
```

### Exemples de premières contributions
1. Corriger une typo
2. Ajouter une traduction
3. Améliorer un message d'erreur
4. Ajouter un exemple
5. Écrire un test

---

## 📖 Resources

### Documentation
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [Git Internals](https://git-scm.com/book/en/v2)
- [GitHub CLI](https://cli.github.com/manual/)

### Outils
- [ShellCheck](https://www.shellcheck.net/) - Linter bash
- [Bashate](https://github.com/openstack/bashate) - Style checker
- [BATS](https://github.com/sstephenson/bats) - Testing framework

---

## ❓ FAQ

**Q: Je ne connais pas bien Bash, puis-je contribuer ?**
A: Oui ! Documentation, traductions, tests, idées, design...

**Q: Combien de temps pour une review ?**
A: Généralement 24-48h pour une première réponse.

**Q: Puis-je proposer une grosse feature ?**
A: Oui, mais discute d'abord dans une issue.

**Q: Comment devenir maintainer ?**
A: Contribue régulièrement et montre ton engagement.

---

## 🙏 Merci !

Chaque contribution compte. Que ce soit:
- 🔤 Corriger une faute
- 🐛 Reporter un bug  
- ✨ Coder une feature
- 🌍 Traduire
- ⭐ Juste mettre une étoile

**Tu fais partie de la révolution Gitpush !**

---

*Questions ? Rejoins notre [Discord](https://discord.gg/gitpush) ou ouvre une [discussion](https://github.com/karlblock/gitpush/discussions).*

---

Happy Coding! 🚀✨