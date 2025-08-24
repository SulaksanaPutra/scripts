Metabase Docker Installation Script
This repository contains a shell script to automate the installation and running of Metabase using Docker. The script allows interactive port selection and ensures data persistence through a Docker volume. It is designed to be run easily on a local machine or server.

Requirements
- Linux or macOS system
- Docker installed on the system
- Internet access to pull the latest Metabase image

Installation & Execution
You can execute the script directly from this repository using curl:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/SulaksanaPutra/scripts/main/database/metabase/install_metabase.sh)"

The script will:
- Prompt for the port to run Metabase on (default: 3000)
- Create a Docker volume named `metabase-data` for persistent storage if it doesn't exist
- Pull the latest Metabase Docker image
- Start or restart the Metabase container
- Make Metabase accessible at `http://localhost:<PORT>`
