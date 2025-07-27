output "vault_uri" {
    value = azurerm_key_vault.vault.vault_uri
  }
output "vault_id" {
  value = azurerm_key_vault.vault.id
}
output "secret_name" {
  value = azurerm_key_vault_secret.db_password.name
}