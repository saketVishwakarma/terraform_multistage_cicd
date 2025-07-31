
#this output file is used to expose the outputs of the database server module 
#output FQDN
output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
   description = "FQDN of postgres sql server "
}
#output private dns zone id 
output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
   description = "ID of the dns zone for PostgreSQL Flexible Server"
  
}

output "postgres_subnet_id" {
  value = azurerm_subnet.postgres_subnet.id
  description = "ID of the subnet delegated to PostgreSQL Flexible Server"
}
