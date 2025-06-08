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
| `--yes`                  | Confirmation automatique |
| Protection branche       | Empêche le push direct sur `main`, propose de switch |
| Tag auto                 | Génère un tag s’il n’est pas fourni |
| CHANGELOG automatique    | Mise à jour + commit |
| GitHub release (`gh`)    | Crée une release avec notes |

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

## 📄 Licence

Distribué sous licence MIT © [Karl Block](https://github.com/Karlblock)
