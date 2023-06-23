output "name" {
  value = azurerm_private_endpoint.private_endpoint.name
}

output "id" {
  value = azurerm_private_endpoint.private_endpoint.id
}

output "private_ip" {
  value = azurerm_private_endpoint.private_endpoint.private_service_connection.0.private_ip_address
}