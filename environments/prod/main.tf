module "resource_group" {
  source   = "../../modules/resourcegroup"
  name     = "prod-rg"
  location = var.location
}

module "network" {
  source               = "../../modules/network"
  vnet_name            = "prod-vnet"
  address_space        = ["10.0.0.0/16"]
  subnets              = [{ name = "subnet1", address_prefix = "10.0.1.0/24" },{name = "subnet2", address_prefix = "10.0.1.1/24"}]
  location             = var.location
  resource_group_name  = module.resource_group.name
}

module "nsg" {
  source              = "../../modules/nsg"
  name                = "prod-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "storage" {
  source                = "../../modules/storage"
  storage_account_name  = "prodstorageacct231"
  container_name        = "prodcontainer"
  location              = var.location
  resource_group_name   = module.resource_group.name
}
module "ssh_keys" {
  source                   = "../../modules/ssh_keys_to_keyvault"
}

data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"                  
  key_vault_id = module.keyvault.vault_id  
  depends_on   = [module.keyvault]
}
data "azuread_service_principal" "terraform_sp" {
  display_name = "terraform-sp"
}

module "keyvault" {
  source              = "../../modules/keyvault"
  name                = "prod-keyvault124324"
  location            = var.location
  db_password         = var.db_password
  resource_group_name = module.resource_group.name
  tenant_id           = var.tenant_id
  object_id           = data.azuread_service_principal.terraform_sp.object_id
  depends_on          = [module.storage,module.ssh_keys]
}


# Store SSH keys in Key Vault
resource "azurerm_key_vault_secret" "private_key" {
  name         = "prod-ssh-private-key"
  value        = module.ssh_keys.private_key_pem
  key_vault_id = module.keyvault.vault_id
}

resource "azurerm_key_vault_secret" "public_key" {
  name         = "prod-ssh-public-key"
  value        = module.ssh_keys.public_key_openssh
  key_vault_id = module.keyvault.vault_id
}




module "vm" {
  source               = "../../modules/virtualMachine"
  vm_name              = "prod-vm"
  location             = var.location
  resource_group_name  = module.resource_group.name
  vm_size              = "Standard_B1s"
  admin_username       = var.admin_username
  nsg_id = module.nsg.nsg_id
  private_key          = module.ssh_keys.private_key_pem
  public_key           = module.ssh_keys.public_key_openssh
  subnet_id            = module.network.subnet_ids[0]
  depends_on           = [module.network, module.nsg,module.keyvault,module.ssh_keys]
}

module "database" {
  source               = "../../modules/database"
  name                 = "prod-db12324265"
  location             = "westus2"
  vnet_name            =  module.network.vnet_name
  resource_group_name  = module.resource_group.name
  db_username          = var.db_username
  sku_name             = var.sku_name
  db_password          = data.azurerm_key_vault_secret.db_password.value
  subnet_id            = module.network.subnet_ids[0]
  depends_on           = [module.vm]
  vnet_id = module.network.vnet_id
}
