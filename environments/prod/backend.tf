terraform {
    backend "azurerm" {
      resource_group_name  = "multitfstate-rg"
      storage_account_name = "multitfstatesa12"
      container_name       = "multitfstate"
      key                  = "prod.terraform.tfstate"
    }
}