terraform {
  #backend "azurerm" {}
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

###################################################
# PRE-REQS (RG, VNET, Subs, Delegated Subs, DNS)  #
###################################################
### Random integer to generate unique names
resource "random_integer" "number" {
  min = 0001
  max = 9999
}

### Resource group to deploy the module prerequisite resources into
resource "azurerm_resource_group" "sonarqube_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

### Virtual network to deploy the container group and prerequisite resources into
resource "azurerm_virtual_network" "sonarqube_vnet" {
  name                = "${var.virtual_network_name}-${random_integer.number.result}"
  location            = azurerm_resource_group.sonarqube_rg.location
  resource_group_name = azurerm_resource_group.sonarqube_rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnets required for resources to be deployed + Service Endpoints (Storage, SQL, KeyVault)
resource "azurerm_subnet" "resource_subnets" {
  for_each                                      = { for each in var.subnet_config : each.subnet_name => each }
  resource_group_name                           = azurerm_resource_group.sonarqube_rg.name
  name                                          = "${each.value.subnet_name}-${random_integer.number.result}"
  virtual_network_name                          = azurerm_virtual_network.sonarqube_vnet.name
  address_prefixes                              = each.value.subnet_address_space
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
}

### Subnet to deploy the container group into - Delegated to ACI
resource "azurerm_subnet" "sonarqube_sub_del" {
  for_each                                      = { for each in var.subnet_config_delegated_aci : each.subnet_name => each }
  name                                          = "${each.value.subnet_name}-${random_integer.number.result}"
  resource_group_name                           = azurerm_resource_group.sonarqube_rg.name
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

## Private DNS Zones for resources deployed into the VNET (Storage, SQL, KeyVault)
resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = toset(var.private_dns_zones)
  name                = each.key
  resource_group_name = azurerm_resource_group.sonarqube_rg.name
  tags                = var.tags
}


##################################################
# MODULE TO TEST                                 #
##################################################
# module "sonarcube-aci-internal" {
#   source            = "../.."
#   sonarqube_rg_name = azurerm_resource_group.sonarqube_rg.name
#   kv_config = {
#     name = "sonarqubekv${random_integer.number.result}"
#     sku  = "standard"
#   }
#   sa_config = {
#     name                      = "sonarqubesa${random_integer.number.result}"
#     account_kind              = "StorageV2"
#     account_tier              = "Standard"
#     account_replication_type  = "LRS"
#     min_tls_version           = "TLS1_2"
#     enable_https_traffic_only = true
#     access_tier               = "Hot"
#     is_hns_enabled            = false
#   }
#   mssql_config = {
#     name    = "sonarqubemssql${random_integer.number.result}"
#     version = "12.0"
#   }
#   aci_group_config = {
#     container_group_name = "sonarqubeaci${random_integer.number.result}"
#     ip_address_type      = "Public"
#     os_type              = "Linux"
#     restart_policy       = "OnFailure"
#   }
#   aci_dns_label = "sonarqube-aci-${random_integer.number.result}"
#   caddy_config = {
#     container_name                  = "caddy-reverse-proxy"
#     container_image                 = "caddy:latest" #Check for more versions/tags here: https://hub.docker.com/_/caddy
#     container_cpu                   = 1
#     container_memory                = 1
#     container_environment_variables = null
#     container_commands              = ["caddy", "reverse-proxy", "--from", "sonar.pwd9000.com", "--to", "localhost:9000"]
#   }
#   tags = var.tags
# }