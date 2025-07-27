module "resource_group" {
   source  = "../../modules/resource_group"
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

module "keyvault" {
   source              = "../../modules/keyvault"
   name                = "prod-keyvault"
   location            = var.location
   resource_group_name = module.resource_group.name
   tenant_id           = var.tenant_id
   object_id           = var.object_id
   db_password         = var.db_password
   depends_on          = [module.storage]
}

module "vm" {
   source                  = "../../modules/vm"
   vm_name                = "prod-vm"
   location               = var.location
   resource_group_name    = module.resource_group.name
   vm_size                = "Standard_B1s"
   admin_username         = var.admin_username
   public_key_path        = var.public_key_path
   private_key_path       = var.private_key_path
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