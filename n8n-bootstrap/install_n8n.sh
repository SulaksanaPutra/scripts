#!/bin/bash
# n8n Docker setup script (with Docker auto-install and auto-restart)

set -e  # exit on error

# Configurable variables
N8N_IMAGE="docker.n8n.io/n8nio/n8n"
N8N_VERSION="latest"
N8N_DATA_DIR="$HOME/n8n_data"
N8N_PORT=5678
CONTAINER_NAME="n8n"

echo "=== Setting up n8n with Docker ==="

# --- Check and install Docker if missing ---
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Installing Docker..."
  sudo apt-get update -y
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  # Add Docker’s official GPG key
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  # Setup repo
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io

  echo "✅ Docker installed."
fi

# Ensure Docker service is running
sudo systemctl enable docker
sudo systemctl start docker

# --- Create n8n data directory ---
mkdir -p "$N8N_DATA_DIR"

# --- Pull n8n image ---
echo "Pulling n8n image..."
sudo docker pull $N8N_IMAGE:$N8N_VERSION

# --- Stop old container if exists ---
if [ "$(sudo docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  echo "Stopping and removing existing n8n container..."
  sudo docker stop $CONTAINER_NAME || true
  sudo docker rm $CONTAINER_NAME || true
fi

# --- Run n8n container (with auto-restart) ---
echo "Starting n8n container..."
sudo docker run -d \
  --name $CONTAINER_NAME \
  --restart always \
  -p $N8N_PORT:5678 \
  -v "$N8N_DATA_DIR:/home/node/.n8n" \
  -e TZ="UTC" \
  $N8N_IMAGE:$N8N_VERSION

echo "=== ✅ n8n is running on http://your-server-ip:$N8N_PORT ==="
