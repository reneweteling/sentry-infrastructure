#!/bin/bash

# create infrastructure
cd terraform \
&& envsubst < terraform.tfvars.template > terraform.tfvars \
&& terraform apply

# Update inventory.yml with server IP from Terraform
cd ../ansible

# Get server IP from Terraform
SERVER_IP=$(cd ../terraform && terraform output -raw server_ipv4)

if [ -z "$SERVER_IP" ]; then
    echo "Error: Could not get server IP from Terraform"
    exit 1
fi

# Update inventory with new IP
cat > inventory.yml << EOF
all:
  children:
    servers:
      hosts:
        sentry-server:
          ansible_host: $SERVER_IP
          ansible_user: root
          ansible_ssh_private_key_file: ~/.ssh/id_terraform
          ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
          sentry_version: 25.7.0
      vars:
        ansible_python_interpreter: /usr/bin/python3
EOF

echo "Updated inventory.yml with server IP: $SERVER_IP"

sleep 5

# Run ansible-playbook to update the inventory
ansible-playbook -i inventory.yml playbook.yml