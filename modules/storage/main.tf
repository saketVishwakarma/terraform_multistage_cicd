 resource "azurerm_storage_account" "sa" {
   name                     = var.storage_account_name
   resource_group_name      = var.resource_group_name
   location                 = var.location
   account_tier             = "Standard"
   account_replication_type = "LRS"
 }
resource "azurerm_storage_container" "container" {
   name                  = var.container_name
   storage_account_id    = azurerm_storage_account.sa.id
   container_access_type = "private"
    lifecycle {
     create_before_destroy = true
   }
 }