variable "application_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "primary_location" {
  type = string
}

variable "base_address_space" {
  type = string
}

variable "vpn_address_space" {
  type = string
}

variable "ginika_password" {
  description = "Ginika password"
  type        = string
  sensitive   = true
}
