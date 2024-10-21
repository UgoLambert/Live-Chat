# Utiliser l'image officielle d'Elixir avec Erlang et Elixir 1.17 preinstalles
FROM elixir:1.17

# Installer les dépendances nécessaires pour Elixir et les outils de compilation
RUN apt-get update && apt-get install -y \
    build-essential \
    inotify-tools \
    && apt-get clean

WORKDIR /app

# Installer Hex (le gestionnaire de paquets d'Elixir) et rebar (outil de compilation Erlang)
RUN mix local.hex --force && mix local.rebar --force

# Copy only the dependency files
COPY chat_app/mix.exs chat_app/mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy the rest of the application
COPY chat_app/ .

# Expose port 4000
EXPOSE 4000

# The default command (will be overridden by docker-compose)
CMD ["mix", "phx.server"]
