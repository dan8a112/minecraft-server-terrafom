variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID"
}

variable "location" {
    type = string
    description = "Location where my infrastucture are"
    default = "East US"
}

variable "project" {
    type = string
    description = "Project Name"
    default = "minecraftserver"
}

variable "environment" {
    type = string
    description = "The environment to gaming"
    default = "gaming"
}

variable "tags" {
    type = map(string)
    description = "A map of tags to apply"
    default = {
        enviroment = "dev"
        date = "abr-2025"
        createdBy = "Terraform"
    }
}

variable "admin_username" {
  default = "minecraft"
}

variable "ssh_public_key" {
  description = "Path to your public SSH key"
  type        = string
}

variable "vm_size" {
  default = "Standard_B1ms"
}