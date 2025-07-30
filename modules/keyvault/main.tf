

resource "azurerm_key_vault" "vault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id
    key_permissions = ["Get", "List","Delete"]
    secret_permissions = ["Get", "Set","Delete"]
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.vault.id
}
