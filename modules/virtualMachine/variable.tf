variable "vm_name" {
       type        = string
       description = "Name of the virtual machine"
     }
variable "location" {
       type        = string
       description = "Azure region"
     }
variable "resource_group_name" {
       type        = string
       description = "Resource group name"
     }
variable "subnet_id" {
       type        = string
       description = "Subnet ID"
     }
variable "vm_size" {
       type        = string
       default     = "Standard_B1s"
       description = "VM size"
     }
variable "admin_username" {
       type        = string
       description = "Admin username for SSH"
     }
variable "public_key" {
       type        = string
       description = "Path to SSH public key"
     }
variable "private_key" {
       type        = string
       sensitive = true
       description = "Path to SSH private key"
     }