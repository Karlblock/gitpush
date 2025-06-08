# Makefile pour Gitpush

install:
	@echo "📦 Installation de gitpush..."
	mkdir -p ~/.scripts
	curl -fsSL https://raw.githubusercontent.com/karlblock/gitpush/main/gitpush.sh -o ~/.scripts/gitpush.sh
	chmod +x ~/.scripts/gitpush.sh
	@if ! grep -q 'alias gitpush=' ~/.bashrc; then \
		echo 'alias gitpush="~/.scripts/gitpush.sh"' >> ~/.bashrc && \
		echo "✅ Alias ajouté à ~/.bashrc"; \
	else \
		echo "ℹ️ Alias déjà présent dans ~/.bashrc"; \
	fi
	@source ~/.bashrc || true
	@echo "🚀 Gitpush est installé avec succès."

uninstall:
	@echo "🧹 Suppression de gitpush..."
	rm -f ~/.scripts/gitpush.sh
	sed -i '/alias gitpush=/d' ~/.bashrc
	@echo "❌ Script et alias supprimés."
