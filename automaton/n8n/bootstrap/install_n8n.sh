#!/bin/bash
# n8n Docker setup script (interactive with defaults)

set -e  # exit on error

# Configurable defaults
N8N_IMAGE="n8nio/n8n"
N8N_VERSION="latest"
N8N_DATA_DIR="$HOME/n8n_data"
N8N_PORT=5678
CONTAINER_NAME="n8n"
PUBLIC_IP=$(curl -s ifconfig.me || echo "localhost")

# --- Ask user with defaults ---
read -rp "Secure cookie? (true/false) [default: false]: " SECURE_COOKIE
SECURE_COOKIE=${SECURE_COOKIE:-false}

read -rp "Editor base URL [default: http://$PUBLIC_IP:$N8N_PORT/]: " EDITOR_URL
EDITOR_URL=${EDITOR_URL:-"http://$PUBLIC_IP:$N8N_PORT/"}

read -rp "Timezone (e.g. UTC, Asia/Jakarta) [default: UTC]: " TZ
TZ=${TZ:-UTC}

echo "=== Config summary ==="
echo "Port: $N8N_PORT"
echo "Editor Base URL: $EDITOR_URL"
echo "Secure Cookie: $SECURE_COOKIE"
echo "Timezone: $TZ"
read -rp "Press Enter to continue with this configuration..."

echo "=== Setting up n8n with Docker ==="

# --- Install Docker if missing ---
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Installing Docker..."
  apt-get update -y
  apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io
  echo "✅ Docker installed."
fi

# Ensure Docker service is running
systemctl enable docker
systemctl start docker

# --- Prepare data directory ---
mkdir -p "$N8N_DATA_DIR"
chown -R 1000:1000 "$N8N_DATA_DIR"
chmod 700 "$N8N_DATA_DIR" || true

# --- Pull n8n image ---
echo "Pulling n8n image..."
docker pull $N8N_IMAGE:$N8N_VERSION

# --- Remove old container ---
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  echo "Stopping and removing existing n8n container..."
  docker rm -f $CONTAINER_NAME || true
fi

# --- Run container ---
echo "Starting n8n container..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart always \
  -p $N8N_PORT:5678 \
  -v "$N8N_DATA_DIR:/home/node/.n8n" \
  -e TZ="$TZ" \
  -e N8N_PORT=$N8N_PORT \
  -e N8N_EDITOR_BASE_URL="$EDITOR_URL" \
  -e N8N_SECURE_COOKIE=$SECURE_COOKIE \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
  $N8N_IMAGE:$N8N_VERSION

echo "=== ✅ n8n is running on $EDITOR_URL ==="
