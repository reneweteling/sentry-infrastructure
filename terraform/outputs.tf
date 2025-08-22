# Server information
output "server_id" {
  description = "ID of the created server"
  value       = hcloud_server.cax31_server.id
}

output "server_name" {
  description = "Name of the created server"
  value       = hcloud_server.cax31_server.name
}

output "server_ipv4" {
  description = "IPv4 address of the server"
  value       = hcloud_server.cax31_server.ipv4_address
}

output "server_ipv6" {
  description = "IPv6 address of the server"
  value       = hcloud_server.cax31_server.ipv6_address
}

output "server_private_ip" {
  description = "Private IP address of the server"
  value       = [for network in hcloud_server.cax31_server.network : network.ip][0]
}

output "server_status" {
  description = "Status of the server"
  value       = hcloud_server.cax31_server.status
}

output "server_location" {
  description = "Location of the server"
  value       = hcloud_server.cax31_server.location
}

# Network information
output "network_id" {
  description = "ID of the created network"
  value       = hcloud_network.main.id
}

output "network_name" {
  description = "Name of the created network"
  value       = hcloud_network.main.name
}

output "network_ip_range" {
  description = "IP range of the network"
  value       = hcloud_network.main.ip_range
}

# Firewall information
output "firewall_id" {
  description = "ID of the created firewall"
  value       = hcloud_firewall.main.id
}

output "firewall_name" {
  description = "Name of the created firewall"
  value       = hcloud_firewall.main.name
}

# Floating IP information (if created)
output "floating_ip" {
  description = "Floating IP address (if created)"
  value       = var.create_floating_ip ? hcloud_floating_ip.main[0].ip_address : null
}

output "floating_ip_id" {
  description = "ID of the floating IP (if created)"
  value       = var.create_floating_ip ? hcloud_floating_ip.main[0].id : null
}

# Connection information
output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh root@${hcloud_server.cax31_server.ipv4_address}"
}

output "server_urls" {
  description = "Server URLs for common services"
  value = {
    http  = "http://${hcloud_server.cax31_server.ipv4_address}"
    https = "https://${hcloud_server.cax31_server.ipv4_address}"
  }
} 