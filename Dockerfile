# Compilation Crystal
FROM crystallang/crystal:1.14.0 AS crystal-builder
WORKDIR /crystal
COPY src/crystal/shard.yml src/crystal/shard.lock* ./
RUN shards install
COPY src/crystal/ ./
RUN shards build --release --no-debug

# Image finale Ruby + Crystal binaire
FROM ruby:3.3-slim-bookworm

COPY --from=crystal-builder /crystal/bin/fluxy_transformer /usr/local/bin/

# Installation les dépendances système + outils de compilation
RUN apt-get update && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y --no-install-recommends \
    libssl-dev libpcre2-dev libgc-dev \
    build-essential ruby-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copie le binaire Crystal
COPY --from=crystal-builder /crystal/bin/fluxy_transformer /app/bin/fluxy_transformer

# Copie le code Ruby
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

# Rend le binaire exécutable
RUN chmod +x /app/bin/fluxy_transformer

# Point d'entrée
ENTRYPOINT ["bundle", "exec", "bin/fluxycore"]