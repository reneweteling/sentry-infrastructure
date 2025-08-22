# Ansible Setup for Sentry Server

This Ansible setup provisions the server created by Terraform and installs Docker with Sentry.

## Prerequisites

1. Ansible installed on your local machine
2. SSH access to the server (188.245.210.198)
3. SSH key configured for authentication

## Installation

1. Install Ansible dependencies:

```bash
pip install -r requirements.txt
```

2. Ensure your SSH key is available:

```bash
# Make sure your SSH key is in the default location
ls ~/.ssh/id_rsa
```

## Usage

### Run the playbook:

```bash
ansible-playbook -i inventory.yml playbook.yml
```

### Test connection first:

```bash
ansible -i inventory.yml servers -m ping
```

## What the playbook does:

1. **Updates the system** - Updates apt cache and installs required packages
2. **Installs Docker** - Adds Docker repository and installs Docker CE
3. **Configures Docker** - Starts Docker service and adds user to docker group
4. **Installs Docker Compose** - Installs docker-compose via pip
5. **Creates Sentry configuration** - Sets up docker-compose.yml with Sentry, PostgreSQL, Redis, and Nginx
6. **Creates Nginx configuration** - Sets up reverse proxy for Sentry

## After running the playbook:

1. SSH into the server:

```bash
ssh root@188.245.210.198
```

2. Start Sentry:

```bash
cd /root
docker-compose up -d
```

3. Access Sentry:
   - Web interface: http://188.245.210.198:9000
   - Initial setup will be required

## Configuration

Before starting Sentry, update the email configuration in `/root/docker-compose.yml`:

- Replace `your-email@gmail.com` with your actual email
- Replace `your-app-password` with your Gmail app password
- Update the `SENTRY_SECRET_KEY` with a secure random string

## Security Notes

- The current setup allows SSH access from any IP (192.168.1.0/24)
- Consider restricting SSH access to your specific IP address
- Set up SSL certificates for production use
- Change default passwords in the docker-compose.yml file

## Troubleshooting

If you encounter issues:

1. Check SSH connectivity:

```bash
ssh root@188.245.210.198
```

2. Check Docker status:

```bash
docker --version
docker-compose --version
```

3. Check Sentry logs:

```bash
cd /root/sentry-self-hosted
docker compose logs sentry
```

4. Check Kafka lock file issues:

```bash
# If Kafka fails to start due to lock files
docker compose down
docker volume rm sentry-kafka sentry-kafka-log
docker compose up -d
```
