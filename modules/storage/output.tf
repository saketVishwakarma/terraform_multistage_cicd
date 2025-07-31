output "storage_account_name" {
    value = azurerm_storage_account.sa.name
    description = "value of the storage account name"
  }
output "container_name" {
    value = azurerm_storage_container.container.name
    description = "value of the storage container name"
  }

output "storage_account_id" {
    value = azurerm_storage_account.sa.id
    description = "ID of the storage account"
  }