variable "name" {
         type        = string
         description = "Database server name it should be unique"
       }
variable "resource_group_name" {
         type        = string
         description = "Resource group name"
       }
variable "location" {
        type        = string
        description = "Azure region"
}
variable "db_username" {
         type        = string
         description = "Database admin username"
       }
variable "db_password" {
  type        = string
  description = "Password for the database"
  sensitive   = true
}
variable "subnet_id" {
         type        = string
         description = "Subnet for private access"
}

variable "sku_name" {
  type        = string
  description = "Valid SKU name for PostgreSQL Flexible Server"

  validation {
    condition = contains([
      "Standard_B1ms",
      "Standard_B2ms",
      "Standard_D2s_v3",
      "Standard_D4s_v3",
      "Standard_E2s_v3",
      "GP_Standard_D4ds_v4",
      "GP_Standard_D2s_v3"
    ], var.sku_name)

    error_message = "Invalid SKU name! Allowed values are: Standard_B1ms, Standard_B2ms, Standard_D2s_v3, Standard_D4s_v3, Standard_E2s_v3."
  }
}
variable "vnet_id" {
  type        = string
  description = "Virtual Network ID where the database will be deployed"
  
}
variable "vnet_name" {
  type = string
  description = "Virtual Network name where the database will be deployed"
}
