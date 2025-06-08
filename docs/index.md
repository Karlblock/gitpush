---
title: gitpush – CLI Git Assistant
---

# 🚀 gitpush

> Un assistant Git interactif pour ne plus jamais faire `git add . && git commit -m "" && git push` sans réfléchir.

![gitpush](../assets/gitpush-v0.3.png)

## ✨ Fonctions

- 🚫 Alerte sur branche `main`
- 🔀 Menu de changement ou création de branche
- ✍️ Commit propre et requis
- 🏷️ Tag automatique (ou manuel)
- 🚀 Release GitHub
- 🌐 Ouverture auto de la page du repo

---

## 🔧 Installation

```bash
curl -o gitpush https://raw.githubusercontent.com/Karlblock/gitpush/main/gitpush.sh
chmod +x gitpush
sudo mv gitpush /usr/local/bin/gitpush
