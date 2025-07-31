variable "name" {
       type        = string
       description = "Name of the Key Vault"
     }
variable "location" {
       type        = string
       description = "Azure location"
     }
variable "resource_group_name" {
       type        = string
       description = "Resource group name"
     }
variable "tenant_id" {
       type        = string
       description = "Tenant ID"
     }
variable "object_id" {
       type        = string
       description = "Object ID for access policy"
     }
variable "db_password" {
  type = string
  description = "password for database "
  sensitive = true
  
}