resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store Private Key in Key Vault
resource "azurerm_key_vault_secret" "private_key" {
  name         = var.private_key_secret_name
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = var.keyvault_id
}

# Store Public Key in Key Vault
resource "azurerm_key_vault_secret" "public_key" {
  name         = var.public_key_secret_name
  value        = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = var.keyvault_id
}