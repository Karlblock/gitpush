# 📦 Changelog – gitpush

Toutes les modifications notables du projet seront documentées ici.

---

## [v1.0.0-beta] - 2025-06-28

### 🚀 Release majeure - Première version beta complète

Cette version représente des mois de développement intensif et transforme gitpush d'un simple script de commit/push en une plateforme complète d'automatisation Git avec intelligence artificielle.

### ✨ Nouvelles fonctionnalités majeures

#### 🤖 Intelligence Artificielle
- **Multi-providers AI** : Support complet d'OpenAI, Anthropic Claude, Google Gemini et modèles locaux
- **Génération automatique de commits** : Messages de commit intelligents basés sur l'analyse des changements
- **Résolution de conflits assistée** : L'IA aide à résoudre les conflits de merge
- **Analyse de code** : Suggestions et améliorations automatiques du code
- **Configuration flexible** : `.gitpush.config` pour personnaliser les paramètres AI

#### 📊 Analytics & Statistiques
- **Tableau de bord complet** : Visualisation des statistiques de commits, branches, contributeurs
- **Métriques détaillées** : Analyse des patterns de développement et productivité
- **Export de données** : Génération de rapports en JSON/CSV
- **Tracking en temps réel** : Suivi des performances du projet

#### 🖥️ Interface Graphique (GUI)
- **Application Electron** : Interface moderne et intuitive pour gitpush
- **Visualisation des commits** : Timeline interactive des changements
- **Gestion des branches** : Création, switch et merge visuels
- **Configuration visuelle** : Paramétrage facile sans ligne de commande

#### 👥 Fonctionnalités Team
- **Collaboration en équipe** : Support multi-utilisateurs avec rôles et permissions
- **Templates de messages** : Standards de commit partagés
- **Workflow personnalisés** : Pipelines adaptés aux besoins de l'équipe
- **Notifications** : Alertes sur les événements importants

#### 🔌 Système de Plugins
- **Architecture modulaire** : Ajout facile de nouvelles fonctionnalités
- **API de plugins** : Interface standardisée pour les extensions
- **Marketplace** : Partage et découverte de plugins communautaires
- **Hooks personnalisés** : Points d'extension dans le workflow

#### 🧪 Tests & Qualité
- **Suite de tests complète** : Tests unitaires et d'intégration
- **CI/CD intégré** : Pipelines automatisés pour la qualité du code
- **Coverage reports** : Analyse de la couverture de tests
- **Linting & formatting** : Standards de code automatisés

#### 📚 Documentation
- **Documentation complète** : Guides d'utilisation, API, architecture
- **Tutoriels interactifs** : Apprentissage progressif des fonctionnalités
- **Exemples pratiques** : Cas d'usage réels et démonstrations
- **Contributing guide** : Guide pour les contributeurs

### 🔧 Améliorations techniques
- **Refactoring complet** : Architecture modulaire et maintenable
- **Performance optimisée** : Exécution plus rapide et efficace
- **Gestion d'erreurs robuste** : Meilleure résilience et messages clairs
- **Compatibilité étendue** : Support Linux, macOS, Windows (WSL)

### 📋 Fichiers ajoutés
- `.gitpush.config.example` : Template de configuration
- `AI_SETUP.md` : Guide de configuration AI
- `CONTRIBUTING.md` : Guide pour contributeurs
- `ROADMAP.md` : Vision et planification future
- `lib/` : Modules organisés (ai/, analytics/, team/, plugins/, utils/)
- `gui/` : Application Electron complète
- `plugins/` : Plugins d'exemple et API
- `tests/` : Suite de tests complète

### 🔄 Migration
- Compatible avec les versions précédentes
- Script de migration automatique pour les configurations existantes
- Documentation de migration détaillée

---

## [v3.0.0] - 2025-06-08
### 🎉 Version majeure
- ✅ Stabilisation de toutes les fonctionnalités
- 🔧 Support des flags `--version`, `--help`, `--simulate`, `--yes`
- 🖥️ Ajout d’un installateur graphique `.desktop`
- 🧰 `install.sh` intelligent pour bash/zsh
- 🧪 `make install` / `make uninstall` prêts pour intégration
- 🧠 Structure du projet prête pour publication publique

---

## [v0.3] - 2025-06-08
### Ajouté
- 🔀 Menu interactif après refus de push sur `main` (switch ou création de branche)
- ✍️ Résumé visuel clair en fin de session
- 🖼️ Ajout de support pour bannière ASCII et image d’aperçu
- 🏷️ Génération auto de tag (`vX.Y.Z`) + commit du `CHANGELOG.md`
- 🚀 Création de release GitHub via `gh`

---

## [v0.2] - 2025-06-06
### Ajouté
- 💬 Message de commit obligatoire avec validation
- 🔄 Option `pull --rebase` avant push
- 🧠 Préparation à l'ajout de message auto / IA

---

## [v0.1] - 2025-06-05
### Créé
- 🛠️ Script initial avec bannière, `git add`, commit et push simples
