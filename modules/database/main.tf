resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "postgres_subnet" {
  name                 = "postgres-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_id = var.vnet_name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "devvnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_subnet" "postgres_subnet" {
  name                 = "postgres-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
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
     elegated_subnet_id    = azurerm_subnet.postgres_subnet.id
     private_dns_zone_id =  azurerm_private_dns_zone.postgres_dns.id
     zone                   = "1"
     public_network_access_enabled = false

    #lifecycle {
      # prevent_destroy = true
     #}
   }
