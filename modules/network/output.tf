output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
  description = "value of the virtual network ID"
}
output "subnet_ids" {
  value = [for s in azurerm_subnet.subnet : s.id]
  description = "values of the subnet IDs in the virtual network"
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
  description = "value of the virtual network name"
}

