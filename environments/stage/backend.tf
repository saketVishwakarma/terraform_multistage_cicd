terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }


backend "azurerm" {
      resource_group_name  = "tfstate-rg"
      storage_account_name = "tfstatestorageacct"
      container_name       = "tfstate"
      key                  = "stage.terraform.tfstate"
}
}
