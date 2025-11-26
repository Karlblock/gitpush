# Makefile pour Gitpush

install:
	@echo "Installation de gitpush..."
	mkdir -p ~/.scripts
	curl -fsSL https://raw.githubusercontent.com/karlblock/gitpush/main/gitpush.sh -o ~/.scripts/gitpush.sh
	chmod +x ~/.scripts/gitpush.sh
	@if ! grep -q 'alias gitpush=' ~/.bashrc; then \
		echo 'alias gitpush="~/.scripts/gitpush.sh"' >> ~/.bashrc && \
		echo "Alias ajoute a ~/.bashrc"; \
	else \
		echo "Alias deja present dans ~/.bashrc"; \
	fi
	@source ~/.bashrc || true
	@echo "Gitpush installe avec succes."

uninstall:
	@echo "Suppression de gitpush..."
	rm -f ~/.scripts/gitpush.sh
	sed -i '/alias gitpush=/d' ~/.bashrc
	@echo "Script et alias supprimes."
