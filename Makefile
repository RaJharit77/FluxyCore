.PHONY: build test ruby-test crystal-test lint rubocop ameba docker-build ci

# Variables
CRYSTAL_DIR = src/crystal
BINARY = bin/fluxy_transformer

# Compilation du binaire Crystal
build:
	cd $(CRYSTAL_DIR) && shards build
	mkdir -p bin
	cp $(CRYSTAL_DIR)/bin/fluxy_transformer $(BINARY)
	@echo "✅ Crystal binary built at $(BINARY)"

# Nettoyage des fichiers générés
clean:
	rm -f $(BINARY)
	rm -rf $(CRYSTAL_DIR)/bin

# Tests Crystal (unitaires)
crystal-test:
	cd $(CRYSTAL_DIR) && crystal spec --order random

# Tous les tests
test: ruby-test crystal-test
	@echo "✅ All tests passed"

ruby-test:
	bundle exec ruby -Ilib test/test_pipeline.rb
	$@echo "✅ Ruby tests passed"

run-example: build
	bundle exec bin/fluxycore examples/csv_aggregation.rb
	$@echo "✅ Example script executed successfully"

# Linting Ruby
rubocop:
	bundle exec rubocop

# Linting Crystal
ameba:
	cd $(CRYSTAL_DIR) && shards exec ameba

# Linting complet
lint: rubocop ameba

# Construction de l'image Docker
docker-build:
	docker build -t fluxycore:latest .

# Lancement d'un pipeline via Docker
docker-run:
	docker run --rm -v $(CURDIR)/data:/app/data -v $(CURDIR)/output:/app/output fluxycore examples/csv_aggregation.rb

# CI complète (build + lint + test)
ci: build lint test