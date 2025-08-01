# New azure virtual netwok 
resource "azurerm_virtual_network" "vnet" {
   name                = var.vnet_name
   address_space       = var.address_space
   location            = var.location
   resource_group_name = var.resource_group_name
 }

 #azure virtual subnet
# This will create subnets based on the input variable 'subnets'
resource "azurerm_subnet" "subnet" {
    count = length(var.subnets)
    name                 = var.subnets[count.index].name
    address_prefixes     = [var.subnets[count.index].address_prefix]
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
  

    lifecycle {
        create_before_destroy = true
    }
}
