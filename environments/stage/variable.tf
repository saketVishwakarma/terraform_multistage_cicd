variable "location" {
  type        = string
  description = "Azure region to deploy resources"
}

variable "admin_username" {
  type        = string
  description = "VM admin username"
}

variable "public_key_path" {
  type        = string
  description = "Path to SSH public key"
}

variable "private_key_path" {
  type        = string
  description = "Path to SSH private key"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "object_id" {
  type        = string
  description = "Azure AD object ID for Key Vault access"
}

variable "db_username" {
  type        = string
  description = "Database admin username"
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault name"
}

variable "keyvault_rg" {
  type        = string
  description = "Resource group for Key Vault"
}
variable "db_password" {
  type = string
  sensitive = true
  
}
