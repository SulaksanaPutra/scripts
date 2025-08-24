#!/bin/bash

# Script to install Docker if missing and run MongoDB (optionally Mongo Express)

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. MongoDB configuration
read -p "Enter MongoDB container name [mongodb]: " MONGO_CONTAINER_NAME
MONGO_CONTAINER_NAME=${MONGO_CONTAINER_NAME:-mongodb}

read -p "Enter MongoDB root username [admin]: " MONGO_ROOT_USER
MONGO_ROOT_USER=${MONGO_ROOT_USER:-admin}

read -p "Enter MongoDB root password [secret]: " MONGO_ROOT_PASS
MONGO_ROOT_PASS=${MONGO_ROOT_PASS:-secret}

read -p "Enter MongoDB database name [mongodb]: " MONGO_DB
MONGO_DB=${MONGO_DB:-mongodb}

read -p "Enter MongoDB port [27017]: " MONGO_PORT
MONGO_PORT=${MONGO_PORT:-27017}

# 2. Ask if GUI (Mongo Express) should be installed
read -p "Do you want to install Mongo Express web GUI? (y/n) [y]: " INSTALL_GUI
INSTALL_GUI=${INSTALL_GUI:-y}

# If yes, ask for Mongo Express configuration
if [[ "$INSTALL_GUI" =~ ^[Yy]$ ]]; then
    read -p "Enter Mongo Express container name [mongo-express]: " ME_CONTAINER_NAME
    ME_CONTAINER_NAME=${ME_CONTAINER_NAME:-mongo-express}

    read -p "Enter Mongo Express port [8081]: " ME_PORT
    ME_PORT=${ME_PORT:-8081}
fi

# 3. Install Docker if missing
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce
    else
        echo "Unsupported OS. Please install Docker manually."
        exit 1
    fi
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installed successfully."
else
    echo "Docker is already installed."
fi

# 4. Run MongoDB container with persistent volume
if [ "$(docker ps -aq -f name=$MONGO_CONTAINER_NAME)" ]; then
    echo "MongoDB container '$MONGO_CONTAINER_NAME' already exists."
else
    echo "Running MongoDB container..."
    docker run -d \
        --name $MONGO_CONTAINER_NAME \
        -e MONGO_INITDB_ROOT_USERNAME=$MONGO_ROOT_USER \
        -e MONGO_INITDB_ROOT_PASSWORD=$MONGO_ROOT_PASS \
        -e MONGO_INITDB_DATABASE=$MONGO_DB \
        -p $MONGO_PORT:27017 \
        -v ${MONGO_CONTAINER_NAME}_data:/data/db \
        mongo:latest
    echo "MongoDB container '$MONGO_CONTAINER_NAME' is running on port $MONGO_PORT."
fi

# 5. Run Mongo Express container if chosen
if [[ "$INSTALL_GUI" =~ ^[Yy]$ ]]; then
    if [ "$(docker ps -aq -f name=$ME_CONTAINER_NAME)" ]; then
        echo "Mongo Express container '$ME_CONTAINER_NAME' already exists."
    else
        echo "Running Mongo Express container..."
        docker run -d \
            --name $ME_CONTAINER_NAME \
            --link $MONGO_CONTAINER_NAME:mongo \
            -e ME_CONFIG_MONGODB_ADMINUSERNAME=$MONGO_ROOT_USER \
            -e ME_CONFIG_MONGODB_ADMINPASSWORD=$MONGO_ROOT_PASS \
            -e ME_CONFIG_MONGODB_SERVER=$MONGO_CONTAINER_NAME \
            -p $ME_PORT:8081 \
            mongo-express
        echo "Mongo Express container '$ME_CONTAINER_NAME' is running on port $ME_PORT."
    fi
    echo "Access Mongo Express at http://localhost:$ME_PORT"
fi

echo "Setup complete."
