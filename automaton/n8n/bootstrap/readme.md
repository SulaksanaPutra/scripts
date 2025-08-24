# n8n Docker Installation Script

This repository contains a shell script to automate the installation and running of n8n using Docker. The script allows interactive configuration with sensible defaults, including port, editor URL, timezone, and secure cookie settings. It is designed to be run easily on a local machine or server.

## Requirements

- Linux server (Ubuntu, Debian, CentOS, or RHEL)
- Docker installed (the script can install Docker if missing)
- Internet access to pull the latest n8n Docker image
- `sudo` privileges for Docker installation

## Installation & Execution

You can execute the script directly from GitHub using `curl`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/SulaksanaPutra/scripts/main/automation/n8n/install_n8n.sh)"
