variable "subscriptions" {
  type = map(string)
  default = {
    dev     = "sub-id-for-dev"
    staging = "sub-id-for-staging"
    prod    = "sub-id-for-prod"
  }
}
variable "tenant_id" {
  
}