 resource "azurerm_storage_account" "sa" {
   name                     = var.storage_account_name
   resource_group_name      = var.resource_group_name
   location                 = var.location
   account_tier             = "Standard"
   account_replication_type = "LRS"
 }
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  container_access_type = "private"
  storage_account_name = azurerm_storage_account.sa.name
  lifecycle {
    create_before_destroy = true
  }
}
