resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "devvnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}



 resource "azurerm_postgresql_flexible_server" "db" {
     name                   = var.name
     resource_group_name    = var.resource_group_name
     location               = var.location
     administrator_login    = var.db_username
     administrator_password = var.db_password
     sku_name               = var.sku_name
     version                = "13"
     storage_mb             = 32768
     delegated_subnet_id    = var.subnet_id
     private_dns_zone_id =  azurerm_private_dns_zone.postgres_dns.id
     zone                   = "1"

    #lifecycle {
      # prevent_destroy = true
     #}
   }