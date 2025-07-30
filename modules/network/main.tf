resource "azurerm_virtual_network" "vnet" {
   name                = var.vnet_name
   address_space       = var.address_space
   location            = var.location
   resource_group_name = var.resource_group_name
 }
resource "azurerm_subnet" "subnet" {
    count                = length(var.subnets)
    name                 = var.subnets[count.index].name
    address_prefixes     = [var.subnets[count.index].address_prefix]
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    dynamic "delegation" {
    for_each = var.subnets[count.index].delegate_postgres ? [1] : []
    content {
      name = "delegation"
      service_delegation {
        name = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
}
    lifecycle {
        create_before_destroy = true
    }
}
