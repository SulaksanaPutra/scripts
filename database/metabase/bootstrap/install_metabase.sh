#!/bin/bash

# Metabase installation script using Docker with interactive port selection

# Exit on any error
set -e

# Prompt user for port
read -p "Enter the port to run Metabase on [default: 3000]: " USER_PORT
PORT=${USER_PORT:-3000}  # Use default 3000 if input is empty

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker first."
    exit 1
fi

# Create a Docker volume for Metabase data persistence if it doesn't exist
docker volume inspect metabase-data >/dev/null 2>&1 || docker volume create metabase-data

# Pull the latest Metabase image
echo "Pulling the latest Metabase image..."
docker pull metabase/metabase:latest

# Check if a container is already running
if [ "$(docker ps -q -f name=metabase)" ]; then
    echo "Metabase container is already running. Restarting..."
    docker restart metabase
else
    # Run Metabase container
    echo "Starting Metabase on port $PORT..."
    docker run -d \
      --name metabase \
      -p $PORT:3000 \
      -v metabase-data:/metabase-data \
      --restart unless-stopped \
      metabase/metabase:latest
fi

echo "Metabase is running at http://localhost:$PORT"
