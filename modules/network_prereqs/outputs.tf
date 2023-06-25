output "vnet_id" {
  value = azurerm_virtual_network.sonarqube_vnet.id
  description = "The resource ID for the sonarqube virtual network."
}

output "vnet_address_space" {
  value = azurerm_virtual_network.sonarqube_vnet.address_space
  description = "The address space of the sonarqube virtual network."
}

output "resource_subnet_id" {
  value = azurerm_subnet.sonarqube_resource_subnet.id
  description = "The resource ID for the sonarqube resource subnet."
}

output "resource_subnet_address_prefix" {
  value = azurerm_subnet.sonarqube_resource_subnet.address_prefix
  description = "The address prefix of the sonarqube resource subnet."
}

output "delegated_subnet_id" {
  value = azurerm_subnet.sonarqube_delegated_subnet.id
  description = "The resource ID for the sonarqube delegated subnet."
}

output "delegated_subnet_address_prefix" {
  value = azurerm_subnet.sonarqube_delegated_subnet.address_prefix
  description = "The address prefix of the sonarqube delegated subnet."
}

output "private_dns_zone_ids" {
  value = azurerm_private_dns_zone.sonarqube_private_dns_zone.*.id
  description = "The ids of the sonarqube private dns zones."
}

output "private_dns_zone_vnet_link_ids" {
  value = azurerm_private_dns_zone_virtual_network_link.vnet-link.*.id
  description = "The ids of the sonarqube private dns zone vnet links."
}