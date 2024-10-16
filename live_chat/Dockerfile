# Utiliser l'image officielle d'Elixir avec Erlang et Elixir 1.17 préinstallés
FROM elixir:1.17

# Installer les dépendances nécessaires pour Elixir et les outils de compilation
RUN apt-get update && apt-get install -y \
    build-essential \
    inotify-tools \
    && apt-get clean

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Installer Hex (le gestionnaire de paquets d'Elixir) et rebar (outil de compilation Erlang)
RUN mix local.hex --force && mix local.rebar --force

# Copier le fichier mix.exs et mix.lock dans le conteneur pour installer les dépendances
# COPY mix.exs mix.lock ./

# Installer les dépendances Elixir
# RUN mix deps.get

# Copier le reste du code source dans le conteneur
# COPY ./live_chat /app

# Exposer le port 4000 si tu prévois de servir une application web à l'avenir
EXPOSE 4000

# Démarre une session interactive si on lance le conteneur avec bash
CMD ["iex", "-S", "mix"]
