# 🚀 gitpush — Assistant Git interactif

![version](https://img.shields.io/badge/version-v0.3.2-blue)
![license](https://img.shields.io/badge/license-MIT-green)

> Un assistant Git en CLI pour des commits propres, interactifs et sans stress.

---

## 📦 Pourquoi `gitpush` ?

Combien de fois tu as fait :

```bash
git add . && git commit -m "" && git push
```

...sans vraiment checker ce que tu faisais ? 😬

➡️ `gitpush` est un outil CLI fun et pratique pour :
- ✅ Avoir un status clair de la branche
- 🧠 Éviter les pushs sur `main` par erreur
- ✍️ Forcer un message de commit utile
- 🚀 Automatiser le tag, le changelog, la release

---

## 🛠️ Fonctionnalités

| Fonction                  | Description |
|--------------------------|-------------|
| `gitpush`                | Lance l’assistant interactif |
| `--version`              | Affiche la version actuelle |
| `--help`                 | Montre l’aide CLI |
| `--simulate`             | Affiche les actions sans les exécuter |
| `--yes`                  | Confirme automatiquement toutes les actions |
| Évite push sur `main`    | Propose de changer/créer une branche |
| Génère un `CHANGELOG.md`| Inclus automatiquement les commits |
| Tag automatique          | Basé sur le dernier tag ou perso |
| GitHub Release (via `gh`)| Crée une release avec tag |

---

## 📸 Aperçu

![Demo GIF](docs/demo.gif)

---

## ⚙️ Installation

### 1. Utilisation rapide avec `install.sh`

```bash
curl -sSL https://raw.githubusercontent.com/Karlblock/gitpush/main/install.sh | bash
```

### 2. Avec `make`

```bash
git clone https://github.com/Karlblock/gitpush.git
cd gitpush
make install
```

---

## 🧪 Simuler sans rien casser

```bash
gitpush --simulate
```

Tu verras exactement ce que l’outil ferait, sans modification réelle 🕵️‍♂️

---

## 📋 Exemple complet

```bash
$ gitpush
📍 Branche actuelle : dev
✏️ Message de commit : fix: amélioration script
🏷️ Créer un tag : oui (auto)
🚀 Release GitHub : oui
```

---

## 🔧 Désinstallation

```bash
make uninstall
```

---

## ☕ Contribuer

- PR bienvenues !
- [Buy Me a Coffee](https://www.buymeacoffee.com/karlblock)

---

## 📄 Licence

MIT — Karl Block 2025
