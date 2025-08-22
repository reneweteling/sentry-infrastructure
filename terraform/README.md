# Hetzner CAX31 Server Terraform Setup

This Terraform configuration provisions a CAX31 server at Hetzner Cloud with networking, firewall, and optional floating IP.

## Features

- **CAX31 Server**: High-performance AMD EPYC server with 8 vCPUs, 16 GB RAM, and 160 GB NVMe SSD
- **Networking**: Private network with custom subnet configuration
- **Firewall**: Pre-configured firewall rules for SSH, HTTP, HTTPS, and ICMP
- **Floating IP**: Optional floating IP for high availability
- **Security**: Configurable SSH access restrictions
- **Backups**: Optional automatic backups
- **Protection**: Server protection against accidental deletion/rebuild

## Prerequisites

1. **Terraform**: Version 1.0 or higher
2. **Hetzner Cloud Account**: With API token
3. **SSH Key** (optional): For secure server access

```sh
brew install hcloud
brew install terraform
```

## Quick Start

### 1. Get Your Hetzner Cloud API Token

1. Go to [Hetzner Cloud Console](https://console.hetzner.cloud/)
2. Navigate to Security → API Tokens
3. Create a new API token with read/write permissions
4. Copy the token

### 2. Configure Your Variables

```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit the configuration
nano terraform.tfvars
```

Update the following required variables:

- `hcloud_token`: Your Hetzner Cloud API token
- `allowed_ssh_ips`: Your IP address for SSH access
- `ssh_key_ids`: Your SSH key IDs (optional)

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

### 6. Connect to Your Server

After successful deployment, you can connect to your server:

```bash
# Using the output from terraform
terraform output ssh_command

# Or manually
ssh root@<server-ip>
```

## Configuration Options

### Server Specifications

The CAX31 server includes:

- **CPU**: 8 vCPUs (AMD EPYC)
- **RAM**: 16 GB
- **Storage**: 160 GB NVMe SSD
- **Network**: 20 TB bandwidth included

### Available Locations

- `nbg1`: Nuremberg, Germany (default)
- `fsn1`: Falkenstein, Germany
- `hel1`: Helsinki, Finland
- `ash`: Ashburn, USA
- `hil`: Hillsboro, USA

### Operating System Images

Common images available:

- `ubuntu-22.04` (default)
- `ubuntu-20.04`
- `debian-12`
- `centos-9`
- `rocky-9`

### Network Configuration

The setup creates:

- Private network: `10.0.0.0/16`
- Subnet: `10.0.1.0/24`
- Server IP: `10.0.1.10`

### Firewall Rules

Default firewall allows:

- SSH (port 22) from specified IPs
- HTTP (port 80) from anywhere
- HTTPS (port 443) from anywhere
- ICMP (ping) from anywhere

## Advanced Configuration

### User Data Script

You can provide a custom user data script that runs on first boot:

```hcl
user_data = <<-EOF
#!/bin/bash
# Your custom initialization script
apt update && apt upgrade -y
apt install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
```

### Floating IP

Enable floating IP for high availability:

```hcl
create_floating_ip = true
```

### Server Protection

Enable protection features:

```hcl
delete_protection = true
rebuild_protection = true
prevent_destroy = true
```

### Backups

Enable automatic backups:

```hcl
enable_backups = true
```

## Outputs

After deployment, Terraform provides useful information:

```bash
# Server details
terraform output server_ipv4
terraform output server_ipv6
terraform output server_private_ip

# Connection command
terraform output ssh_command

# Network information
terraform output network_id
terraform output firewall_id
```

## Security Best Practices

1. **Restrict SSH Access**: Update `allowed_ssh_ips` to your specific IP
2. **Use SSH Keys**: Add your SSH key IDs to `ssh_key_ids`
3. **Enable Protection**: Set `delete_protection = true` for production
4. **Regular Backups**: Enable backups for important data
5. **Monitor Logs**: Check server logs regularly

## Cost Estimation

CAX31 server pricing (approximate):

- **Base Cost**: ~€15.83/month
- **Backups**: +€1.58/month (if enabled)
- **Floating IP**: +€0.50/month (if enabled)

## Troubleshooting

### Common Issues

1. **API Token Error**: Ensure your token has correct permissions
2. **SSH Connection Failed**: Check firewall rules and SSH key configuration
3. **Network Issues**: Verify network zone matches server location

### Useful Commands

```bash
# Check server status
hcloud server list

# View server details
hcloud server describe <server-name>

# SSH into server
ssh root@<server-ip>

# View firewall rules
hcloud firewall list
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete the server and all associated resources.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License.
