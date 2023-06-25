output "vnet_id" {
  value       = azurerm_virtual_network.sonarqube_vnet.id
  description = "The resource ID for the sonarqube virtual network."
}

output "vnet_address_space" {
  value       = azurerm_virtual_network.sonarqube_vnet.address_space
  description = "The address space of the sonarqube virtual network."
}

output "resource_subnets" {
  value       = azurerm_subnet.resource_subnets
  description = "output the resource subnet objects."
}

output "delegated_subnets" {
  value       = azurerm_subnet.sonarqube_sub_del
  description = "output the delegated subnet objects."
}

output "private_dns_zones" {
  value       = azurerm_private_dns_zone.private_dns_zones
  description = "output the private dns zone objects."
}

output "private_dns_zone_vnet_links" {
  value       = azurerm_private_dns_zone_virtual_network_link.vnet-link
  description = "output the private dns zone vnet link objects."
}