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
     zone                   = "1"

    lifecycle {
       prevent_destroy = true
     }
   }