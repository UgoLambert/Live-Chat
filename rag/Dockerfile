# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Installation des dependances systeme necessaires
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Verifier que requirements.txt est bien copie
COPY rag/ .

# Installation des dependances Python
RUN pip install --no-cache-dir -r requirements.txt

# Ingest code
COPY chat_app/ code_base/

# Le conteneur sera expose sur le port 8000 (a ajuster selon votre application)
EXPOSE 8000

# Commande par defaut pour demarrer l'application
# CMD ["chainlit run main.py --host 0.0.0.0"]