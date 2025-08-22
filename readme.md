# Sentry Infrastructure

This project automates the deployment of a self-hosted Sentry instance on Hetzner Cloud using Terraform for infrastructure provisioning and Ansible for configuration management.

## Overview

The project consists of two main components:

- **Terraform**: Creates and manages the Hetzner Cloud infrastructure (server, network, firewall)
- **Ansible**: Configures the server and installs Sentry self-hosted

## Prerequisites

- Terraform >= 1.0
- Ansible >= 2.9.0
- Docker Compose >= 1.29.0
- Hetzner Cloud account
- GitHub account (for accessing Sentry repositories)

## Environment Variables

Create a `.envrc` file in the root directory with the following required variables:

### Required Variables

1. **`HCLOUD_TOKEN`** - Hetzner Cloud API Token

   - Get this from your Hetzner Cloud Console → Security → API Tokens
   - Used by Terraform to authenticate with Hetzner Cloud API
   - Required for creating servers, networks, and firewalls

2. **`GITHUB_TOKEN`** - GitHub Personal Access Token
   - Create this in GitHub → Settings → Developer settings → Personal access tokens
   - Needs `repo` scope to access Sentry self-hosted repository
   - Used by Ansible to clone the Sentry repository and avoid rate limiting

### Example `.envrc` file

```bash
#!/usr/bin/env bash

# Hetzner Cloud API Token
export HCLOUD_TOKEN="your_hetzner_cloud_api_token_here"

# GitHub Personal Access Token
export GITHUB_TOKEN="your_github_personal_access_token_here"
```

### Loading the environment

After creating the `.envrc` file, load the environment variables:

```bash
# If using direnv (recommended)
direnv allow

# Or manually source the file
source .envrc
```

## Project Structure

```
sentry-infrastructure/
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── outputs.tf            # Output values
│   └── README.md             # Terraform-specific documentation
├── ansible/                  # Configuration management
│   ├── playbook.yml          # Main Ansible playbook
│   ├── inventory.yml         # Server inventory
│   └── requirements.txt      # Ansible dependencies
├── create_and_provision.sh   # Main deployment script
└── README.md                 # This file
```

## Quick Start

1. **Set up environment variables**:

   ```bash
   cp .envrc.example .envrc
   # Edit .envrc with your tokens
   direnv allow
   ```

2. **Deploy the infrastructure**:
   ```bash
   ./create_and_provision.sh
   ```

This script will:

- Create the Hetzner Cloud infrastructure using Terraform
- Update the Ansible inventory with the server IP
- Configure the server and install Sentry using Ansible

## Configuration

### Sentry Version

You can specify a specific Sentry version in the Ansible inventory file (`ansible/inventory.yml`):

```yaml
sentry-server:
  ansible_host: your_server_ip
  ansible_user: root
  ansible_ssh_private_key_file: ~/.ssh/id_terraform
  sentry_version: "25.7.0" # Specify version or use 'latest'
```

- If `sentry_version` is set to a specific version (e.g., "25.7.0"), that version will be installed
- If `sentry_version` is not set or is "latest", the latest version will be fetched from GitHub

### Server Configuration

The default server configuration creates a CAX31 server (4 vCPU, 8GB RAM) in Nuremberg (nbg1). You can modify these settings in `terraform/variables.tf`:

- `server_name`: Name of the server
- `server_location`: Hetzner Cloud location
- `server_image`: Operating system (default: Ubuntu 22.04)

## Accessing Sentry

After successful deployment, Sentry will be available at:

- **URL**: `http://your_server_ip:9000`
- **Admin user**: Created during installation (check logs for credentials)

## Security

- SSH access is restricted to specified IP addresses (configurable in Terraform)
- Firewall rules allow HTTP (80), HTTPS (443), and Sentry (9000) ports
- Server has delete protection enabled by default
- Private network is configured for internal communication

## Troubleshooting

### Common Issues

1. **Terraform authentication error**: Ensure `HCLOUD_TOKEN` is set correctly
2. **GitHub rate limiting**: Ensure `GITHUB_TOKEN` is set with appropriate permissions
3. **SSH connection issues**: Verify the SSH key exists at `~/.ssh/id_terraform`

### Logs

- **Terraform logs**: Check the terraform directory for state files and logs
- **Ansible logs**: Run with `-v` flag for verbose output
- **Sentry logs**: SSH to the server and check Docker container logs

## Cleanup

To destroy the infrastructure:

```bash
cd terraform
terraform destroy
```

⚠️ **Warning**: This will permanently delete the server and all data.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request

## License

This project is licensed under the MIT License.
