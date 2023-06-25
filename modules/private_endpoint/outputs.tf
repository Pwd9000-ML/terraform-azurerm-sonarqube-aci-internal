output "name" {
  value       = azurerm_private_endpoint.private_endpoint.name
  description = "The name of the private endpoint."
}

output "id" {
  value       = azurerm_private_endpoint.private_endpoint.id
  description = "ID value of the private endpoint."
}

output "private_ip" {
  value       = azurerm_private_endpoint.private_endpoint.private_service_connection.0.private_ip_address
  description = "value of the private ip address of the private endpoint."
}