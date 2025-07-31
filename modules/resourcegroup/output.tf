output "name" {
    value = azurerm_resource_group.this.name
    description = "value of the resource group name"
}
output "location" {
    value = azurerm_resource_group.this.location
    description = "value of the resource group location"
}
output "id" {
    value = azurerm_resource_group.this.id
    description = "value of the resource group ID"
}