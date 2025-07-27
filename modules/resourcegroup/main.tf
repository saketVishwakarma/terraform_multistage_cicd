resource "azurerm_resource_group" "this" {
    name     = var.name
    location = var.location
    lifecycle {
         prevent_destroy = true
  
        }
}