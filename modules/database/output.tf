output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}
output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
  
}
output "postgres_subnet_id" {
  value = azurerm_subnet.postgres_subnet.id
  description = "ID of the subnet delegated to PostgreSQL Flexible Server"
}
