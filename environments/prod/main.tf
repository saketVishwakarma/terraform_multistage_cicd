module "resource_group" {
     source  = "../../modules/resourcegroup"
     name    = "prod-rg"
     location = var.location
}
module "network" {
     source              = "../../modules/network"
     vnet_name          = "prod-vnet"
     address_space      = ["10.0.0.0/16"]
     subnets            = [{ name = "subnet1", address_prefix = "10.0.1.0/24" }]
     location           = var.location
     resource_group_name = module.resource_group.name
}
module "nsg" {
     source              = "../../modules/nsg"
     name                = "prod-nsg"
     location            = var.location
     resource_group_name = module.resource_group.name
}
module "storage" {
     source                  = "../../modules/storage"
     storage_account_name   = "prodstorageacct"
     container_name         = "prodcontainer"
     location               = var.location
     resource_group_name    = module.resource_group.name
}
data "azuread_service_principal" "terraform_sp" {
  display_name = "terrraform-sp"
}
module "keyvault" {
     source              = "../../modules/keyvault"
     name                = "prod-keyvault"
     location            = var.location
     db_password         = var.db_password
     resource_group_name = module.resource_group.name
     tenant_id           = var.tenant_id
     object_id = data.azuread_service_principal.terraform_sp.object_id
     depends_on          = [module.storage]
}


module "ssh_keys" {
  source                   = "../../modules/ssh_keys_to_keyvault"
  keyvault_id             = module.keyvault.vault_id
  private_key_secret_name = "prod-ssh-private-key"
  public_key_secret_name  = "prod-ssh-public-key"
}
data "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "prod-ssh-private-key"
  key_vault_id = module.keyvault.vault_id
  depends_on   = [module.keyvault]
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "prod-ssh-public-key"
  key_vault_id = module.keyvault.vault_id
  depends_on   = [module.keyvault]
}

data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"                   # <-- name of the secret in Key Vault
  key_vault_id = module.keyvault.vault_id   # <-- ensure this matches your Key Vault module output
  depends_on   = [module.keyvault]
}



module "vm" {
     source                  = "../../modules/virtualMachine"
     vm_name                = "prod-vm"
     location               = var.location
     resource_group_name    = module.resource_group.name
     vm_size                = "Standard_B1s"
     admin_username         = var.admin_username
     private_key        = data.azurerm_key_vault_secret.ssh_public_key.value
     public_key        = data.azurerm_key_vault_secret.ssh_private_key.value
     subnet_id              = module.network.subnet_ids[0] 
     depends_on             = [module.network, module.nsg]
   }
module "database" {
     source                = "../../modules/database"
     name                  = "prod-db"
     location              = var.location
     resource_group_name   = module.resource_group.name
     db_username        = var.db_username
     sku_name = var.sku_name
     db_password        = data.azurerm_key_vault_secret.db_password.value
     subnet_id             = module.network.subnet_ids[0]
     depends_on            = [module.vm]
   }