# 🚀 gitpush — Assistant Git interactif

```
          _ __                   __  
   ____ _(_) /_____  __  _______/ /_ 
  / __ `/ / __/ __ \/ / / / ___/ __ \
 / /_/ / / /_/ /_/ / /_/ (__  ) / / /
 \__, /_/\__/ .___/\__,_/____/_/ /_/ 
/____/     /_/                       

     🚀 gitpush — by Karl Block
```

[![Shell](https://img.shields.io/badge/script-shell-blue?style=flat-square&logo=gnu-bash)](https://bash.sh)
[![Licence MIT](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Made by Karl Block](https://img.shields.io/badge/made%20by-Karl%20Block-blueviolet?style=flat-square)](https://github.com/Karlblock)
[![Releases](https://img.shields.io/github/v/release/Karlblock/gitpush?style=flat-square)](https://github.com/Karlblock/gitpush/releases)

---

## 🧨 Pourquoi `gitpush` ?

> Combien de fois tu as fait :
> `git add . && git commit -m "" && git push`
> ...sans vraiment checker ce que tu faisais ? 😬

`gitpush` est un outil CLI fun et interactif qui :

- ✅ Affiche la branche et empêche les erreurs sur `main`
- ✍️ Demande un message de commit utile
- 🔄 Propose un `pull --rebase`
- 🏷️ Gère les tags et CHANGELOG automatiquement
- 🚀 Crée une release GitHub via `gh`
- 🧪 Mode simulation possible

---

## 🎥 Démo

![demo](assets/demo.png)

---

## 🛠️ Fonctionnalités

| Fonction                  | Description |
|--------------------------|-------------|
| `gitpush`                | Assistant Git interactif |
| `--version`              | Affiche la version |
| `--help`                 | Affiche l’aide |
| `--simulate`             | Mode simulation sans action |
| `--issues`               | **NOUVEAU** Gestion complète des issues GitHub |
| `--yes`                  | Confirmation automatique |
| Protection branche       | Empêche le push direct sur `main`, propose de switch |
| Tag auto                 | Génère un tag s’il n’est pas fourni |
| CHANGELOG automatique    | Mise à jour + commit |
| GitHub release (`gh`)    | Crée une release avec notes |
| **Issues GitHub** 🆕     | Création, fermeture et gestion des issues |
| **Labels auto** 🆕       | Gestion des labels avec suggestions intelligentes |
| **Détection auto** 🆕    | Fermeture automatique d'issues via commits |
| **Menu interactif** 🆕   | Navigation facile entre Git et Issues |

---

## 🆕 Nouveautés v0.4.0 - Gestion des Issues GitHub

### 🎯 Menu Issues intégré
```bash
gitpush --issues
# ou utilise le menu principal interactif
```

### ⚡ Fonctionnalités issues
- **📋 Lister les issues** ouvertes avec labels
- **➕ Créer des issues** avec sélection de labels intelligente
- **🔒 Fermer des issues** avec commentaires
- **🏷️ Gestion complète des labels** (création, suppression)
- **🤖 Détection automatique** : commits avec `fixes #123` ferment l'issue
- **💡 Suggestions intelligentes** : détection de bugs/features dans les commits

### 🔧 Workflow intelligent
```bash
$ gitpush
📍 Branche actuelle : feature/new-login
✏️ Message de commit : fix: resolve login bug #42
🔗 Détection automatique : ce commit pourrait fermer l'issue #42
❓ Confirmer la fermeture de l'issue #42 ? (y/N) : y
🔄 Pull --rebase : oui
🏷️ Tag : auto (vX.Y.Z)
🚀 GitHub Release : oui
🎯 Accéder au menu Issues ? (y/N) : n
✅ Résumé → lancement ! :
```

---

## 📦 Installation

### 🔧 En une ligne

```bash
curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash
```

### 🔧 Avec Make

```bash
git clone https://github.com/Karlblock/gitpush.git
cd gitpush
make install
```

---

## 💡 Exemple d’utilisation

```bash
$ gitpush
📍 Branche actuelle : dev
✏️ Message de commit : fix: amélioration du script
🔄 Pull --rebase : oui
🏷️ Tag : auto (vX.Y.Z)
🚀 GitHub Release : oui
✅ Résumé → lancement !
```

---

## 🧪 Mode simulation

```bash
gitpush --simulate
```

Utile pour tester sans rien pousser !

---

## 🔧 Désinstallation

```bash
make uninstall
```

---

## 📬 Contribuer

- PR bienvenues : fonctionnalités, CI, docs...
- Discutons sur [Issues](https://github.com/Karlblock/gitpush/issues)

---

## ☕ Me soutenir

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=☕&slug=karlblock&button_colour=FFDD00&font_colour=000000&font_family=Arial&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/karlblock)

---

## 🗺️ Roadmap & Vision

- 📖 [**ROADMAP**](ROADMAP.md) - Découvre l'évolution prévue jusqu'à v1.0
- 🚀 [**VISION**](VISION.md) - Notre philosophie et objectifs long terme  
- ✨ [**NEXT FEATURES**](NEXT_FEATURES.md) - Les prochaines fonctionnalités
- 🤝 [**CONTRIBUTING**](CONTRIBUTING.md) - Rejoins l'aventure !

## 🌟 Pourquoi Gitpush ?

- **🧠 Intelligent** : Détection automatique, suggestions IA (bientôt)
- **🎯 Productif** : Workflows optimisés, moins de commandes
- **🤝 Collaboratif** : Gestion d'équipe intégrée
- **🔌 Extensible** : Architecture plugin-ready
- **🌍 Universel** : Multi-plateforme, multi-langues

## 📊 Stats & Communauté

![GitHub stars](https://img.shields.io/github/stars/Karlblock/gitpush?style=social)
![Contributors](https://img.shields.io/github/contributors/Karlblock/gitpush)
![Discord](https://img.shields.io/discord/123456789?label=Discord&style=social)
![Downloads](https://img.shields.io/github/downloads/Karlblock/gitpush/total)

## 📄 Licence

Distribué sous licence MIT © [Karl Block](https://github.com/Karlblock)
