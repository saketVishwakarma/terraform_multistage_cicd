terraform {
    backend "azurerm" {
      resource_group_name  = "multitfstate-rg"
      storage_account_name = "multitfstatesa12"
      container_name       = "multitfstate"
      key                  = "prod.terraform.tfstate"
    }
}
provider "azurerm" {
  features {
    
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  use_oidc        = true
}
