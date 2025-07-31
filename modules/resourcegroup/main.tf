
# resource group for infra setup in azure
resource "azurerm_resource_group" "this" {
    name     = var.name
    location = var.location
}