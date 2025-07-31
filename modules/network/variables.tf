variable "vnet_name" {
     type        = string
     description = "Name of the virtual network"
}  
variable "address_space" {
     type        = list(string)
     description = "The address space that is used by the virtual network"
}  
variable "subnets" {
     description = "List of subnets with name and address_prefix"
     type = list(object({
       name           = string
       address_prefix = string
     }))
} 
variable "location" {
     type        = string
     description = "Azure region"
}
   
variable "resource_group_name" {
     type        = string
     description = "Name of the resource group"
}