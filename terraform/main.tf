terraform {
  required_version = ">= 1.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Create the CAX31 server
resource "hcloud_server" "cax31_server" {
  name        = var.server_name
  image       = var.server_image
  server_type = "cax31"
  location    = var.server_location
  ssh_keys    = var.ssh_key_ids
  user_data   = var.user_data

  labels = var.server_labels

  # Network configuration
  network {
    network_id = hcloud_network.main.id
    ip         = var.private_ip
  }

  # Firewall configuration
  firewall_ids = [hcloud_firewall.main.id]

  # Backup configuration
  backups = var.enable_backups

  # IPv4 and IPv6 are enabled by default

  # Protection configuration
  delete_protection = var.delete_protection
  rebuild_protection = var.rebuild_protection

  lifecycle {
    prevent_destroy = false
  }
}

# Create a network for the server
resource "hcloud_network" "main" {
  name     = "${var.server_name}-network"
  ip_range = var.network_ip_range
}

# Create a subnet for the network
resource "hcloud_network_subnet" "main" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.subnet_ip_range
}

# Create a firewall
resource "hcloud_firewall" "main" {
  name = "${var.server_name}-firewall"
  
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # Allow ICMP for ping
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # Allow port 9000 for Sentry
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "9000"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# Create a floating IP (optional)
resource "hcloud_floating_ip" "main" {
  count  = var.create_floating_ip ? 1 : 0
  type   = "ipv4"
  description = "Floating IP for ${var.server_name}"
}

# Assign floating IP to server
resource "hcloud_floating_ip_assignment" "main" {
  count = var.create_floating_ip ? 1 : 0
  floating_ip_id = hcloud_floating_ip.main[0].id
  server_id       = hcloud_server.cax31_server.id
} 