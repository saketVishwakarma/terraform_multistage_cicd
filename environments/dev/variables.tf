variable "location" {
  type        = string
  description = "Azure region to deploy resources"
}

variable "admin_username" {
  type        = string
  description = "VM admin username"
}
variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}
variable "db_username" {
  type        = string
  description = "Database admin username"
}

variable "db_password" {
  type = string
  sensitive = true
  
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

    error_message = "Invalid SKU name! Allowed values are: Standard_B1ms, Standard_B2ms, Standard_D2s_v3,GP_Standard_D2s_v3, Standard_D4s_v3, Standard_E2s_v3."
  }
}

variable "subscription_id" {
 type        = string
  description = "Azure subscription ID"
}
variable "client_id" {
 type        = string
  description = "Azure Client ID"
}

