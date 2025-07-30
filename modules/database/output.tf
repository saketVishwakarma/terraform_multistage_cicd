output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}
output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
  
}