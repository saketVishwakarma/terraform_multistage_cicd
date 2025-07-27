provider "azurerm" {
  features {}

  alias           = "default"
  tenant_id       = var.tenant_id
  subscription_id = lookup(var.subscriptions, terraform.workspace)
}