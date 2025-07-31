
output "vault_uri" {
    value = azurerm_key_vault.vault.vault_uri
    description = "value of the key vault URI"
  }

output "vault_id" {
  value = azurerm_key_vault.vault.id
  description = "value of the key vault ID"
}
output "secret_name" {
  value = azurerm_key_vault_secret.db_password.name
  description = "value of the secret name in Key Vault"
}