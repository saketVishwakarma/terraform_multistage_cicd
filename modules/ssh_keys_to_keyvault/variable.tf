variable "keyvault_id" {
  description = "ID of the existing Azure Key Vault"
  type        = string
}

variable "private_key_secret_name" {
  description = "Name of the secret to store the private key"
  type        = string
  default     = "ssh-private-key"
}

variable "public_key_secret_name" {
  description = "Name of the secret to store the public key"
  type        = string
  default     = "ssh-public-key"
}