#####################################################
# PRE-REQS (VNET, Subs, Delegated Subs, DNS, LINKS) #
#####################################################
### Virtual network to deploy the container group and prerequisite resources into
resource "azurerm_virtual_network" "sonarqube_vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.network_resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnets required for resources to be deployed + Service Endpoints (Storage, SQL, KeyVault)
resource "azurerm_subnet" "resource_subnets" {
  count                                         = length(var.subnet_config)
  resource_group_name                           = var.network_resource_group_name
  name                                          = var.subnet_config[count.index].subnet_name
  virtual_network_name                          = azurerm_virtual_network.sonarqube_vnet.name
  address_prefixes                              = var.subnet_config[count.index].subnet_address_space
  service_endpoints                             = var.subnet_config[count.index].service_endpoints
  private_endpoint_network_policies     = var.subnet_config[count.index].private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.subnet_config[count.index].private_link_service_network_policies_enabled
  depends_on                                    = [azurerm_virtual_network.sonarqube_vnet]
}

### Subnet to deploy the container group into - Delegated to ACI
resource "azurerm_subnet" "sonarqube_sub_del" {
  count                                         = length(var.subnet_config_delegated_aci)
  name                                          = var.subnet_config_delegated_aci[count.index].subnet_name
  resource_group_name                           = var.network_resource_group_name
  virtual_network_name                          = azurerm_virtual_network.sonarqube_vnet.name
  address_prefixes                              = var.subnet_config_delegated_aci[count.index].subnet_address_space
  service_endpoints                             = var.subnet_config_delegated_aci[count.index].service_endpoints
  private_endpoint_network_policies     = var.subnet_config_delegated_aci[count.index].private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.subnet_config_delegated_aci[count.index].private_link_service_network_policies_enabled
  delegation {
    name = var.subnet_config_delegated_aci[count.index].delegation_name

    service_delegation {
      name    = var.subnet_config_delegated_aci[count.index].delegation_service
      actions = var.subnet_config_delegated_aci[count.index].delegation_ations
    }
  }
  depends_on = [azurerm_virtual_network.sonarqube_vnet]
}

## Private DNS Zones for resources deployed into the VNET (Storage, SQL, KeyVault and 'l'ocal' private DNS zone for SonarQube instance)
resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = toset(var.private_dns_zones)
  name                = each.key
  resource_group_name = var.network_resource_group_name
  tags                = var.tags
}
## Link Private DNS Zones to VNET
resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  for_each              = toset(var.private_dns_zones)
  name                  = "${each.key}-net-link"
  resource_group_name   = var.network_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.sonarqube_vnet.id
  tags                  = var.tags
}