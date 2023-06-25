#####################################################
# PRE-REQS (VNET, Subs, Delegated Subs, DNS, LINKS) #
#####################################################
### Random integer to generate unique names
#resource "random_integer" "number" {
#  min = 0001
#  max = 9999
#}

### Resource group to deploy the module prerequisite resources into
#resource "azurerm_resource_group" "sonarqube_rg" {
#  name     = var.resource_group_name
#  location = var.location
#  tags     = var.tags
#}

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
  for_each                                      = { for each in var.subnet_config : each.subnet_name => each }
  resource_group_name                           = var.network_resource_group_name
  name                                          = each.value.subnet_name
  virtual_network_name                          = azurerm_virtual_network.sonarqube_vnet.name
  address_prefixes                              = each.value.subnet_address_space
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
}

### Subnet to deploy the container group into - Delegated to ACI
resource "azurerm_subnet" "sonarqube_sub_del" {
  for_each                                      = { for each in var.subnet_config_delegated_aci : each.subnet_name => each }
  name                                          = each.value.subnet_name
  resource_group_name                           = var.network_resource_group_name
  virtual_network_name                          = azurerm_virtual_network.sonarqube_vnet.name
  address_prefixes                              = each.value.subnet_address_space
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  delegation {
    name = each.value.delegation_name

    service_delegation {
      name    = each.value.delegation_service
      actions = each.value.delegation_ations
    }
  }
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