# Metabase Docker Installation Script

This repository contains a shell script to automate the installation and running of Metabase using Docker. The script allows interactive port selection and ensures data persistence through a Docker volume. It is designed to be run easily on a local machine or server.

## Requirements

- Linux or macOS system
- Docker installed on the system
- Internet access to pull the latest Metabase image

## Installation & Execution

You can execute the script directly from GitHub using `curl`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/SulaksanaPutra/scripts/main/database/metabase/install_metabase.sh)"
