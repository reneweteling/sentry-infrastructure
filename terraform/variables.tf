# Hetzner Cloud API Token
variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

# Server configuration
variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = "cax31-server"
}

variable "server_image" {
  description = "Operating system image for the server"
  type        = string
  default     = "ubuntu-22.04"
}

variable "server_location" {
  description = "Location where the server will be created"
  type        = string
  default     = "nbg1"
}

variable "ssh_key_ids" {
  description = "List of SSH key IDs to add to the server"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data script to run on server initialization"
  type        = string
  default     = ""
}

variable "server_labels" {
  description = "Labels to apply to the server"
  type        = map(string)
  default     = {
    environment = "production"
    managed_by  = "terraform"
  }
}

# Network configuration
variable "private_ip" {
  description = "Private IP address for the server"
  type        = string
  default     = "10.0.1.10"
}

variable "network_ip_range" {
  description = "IP range for the network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_ip_range" {
  description = "IP range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "network_zone" {
  description = "Network zone for the subnet"
  type        = string
  default     = "eu-central"
}

# Firewall configuration
variable "allowed_ssh_ips" {
  description = "List of IP addresses allowed to connect via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Server protection and backup settings
variable "enable_backups" {
  description = "Enable automatic backups"
  type        = bool
  default     = false
}

variable "delete_protection" {
  description = "Enable delete protection"
  type        = bool
  default     = false
}

variable "rebuild_protection" {
  description = "Enable rebuild protection"
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "Prevent accidental destruction of the server"
  type        = bool
  default     = false
}

# Floating IP configuration
variable "create_floating_ip" {
  description = "Create a floating IP for the server"
  type        = bool
  default     = false
} 