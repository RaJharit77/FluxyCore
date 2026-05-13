# --- Étape 1 : Compilation Crystal ---
FROM crystallang/crystal:1.14.0 AS crystal-builder
WORKDIR /crystal
COPY src/crystal/shard.yml src/crystal/shard.lock* ./
RUN shards install
COPY src/crystal/ ./
RUN shards build --release --no-debug

# --- Étape 2 : Image finale Ruby + Crystal binaire ---
FROM ruby:3.3-slim

# Installation des dépendances système pour Crystal (si nécessaire, mais le binaire est statique)
RUN apt-get update && apt-get install -y --no-install-recommends libssl-dev libpcre2-dev libgc-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier le binaire Crystal
COPY --from=crystal-builder /crystal/bin/fluxy_transformer /app/bin/fluxy_transformer

# Copier le code Ruby
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

# Rendre le binaire exécutable
RUN chmod +x /app/bin/fluxy_transformer

# Point d'entrée
ENTRYPOINT ["bundle", "exec", "bin/fluxycore"]