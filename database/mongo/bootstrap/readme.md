# MongoDB Bootstrap Script

This repository contains a shell script to automate the installation of Docker, MongoDB, and optionally Mongo Express (web GUI) on a Linux server. It is designed to be run easily on a VPN, local machine, or cloud server.

## Requirements

- Linux server (Ubuntu, Debian, CentOS, or RHEL)
- SSH access to the server
- Internet access
- `sudo` privileges for Docker installation

## Installation & Execution

You can execute the script directly from GitHub using `curl`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/SulaksanaPutra/scripts/main/database/mongo/bootstrap/install_mongodb.sh)"
