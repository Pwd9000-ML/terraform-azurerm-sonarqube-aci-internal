terraform {
  #backend "azurerm" {}
  backend "local" { path = "terraform-example2.tfstate" }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

####################################################
# Create RGs for Networking and Sonarqube instance #
####################################################
### Random integer to generate unique names
resource "random_integer" "number" {
  min = 0001
  max = 9999
}

### Resource group to deploy the module prerequisite networking resources into
resource "azurerm_resource_group" "sonarqube_vnet_rg" {
  name     = var.network_resource_group_name
  location = var.location
  tags     = var.tags
}

### Resource group to deploy the module sonarqube and supporting resources into
resource "azurerm_resource_group" "sonarqube_rg" {
  name     = var.sonarqube_resource_group_name
  location = var.location
  tags     = var.tags
}

##################################################
# MODULE                                         #
##################################################
module "sonarcube-aci-internal" {
  source  = "Pwd9000-ML/sonarqube-aci-internal/azurerm"
  version = ">= 1.1.0"

  #Required
  resource_group_name         = azurerm_resource_group.sonarqube_rg.name
  network_resource_group_name = azurerm_resource_group.sonarqube_vnet_rg.name
  location                    = var.location
  tags                        = var.tags

  #Create networking prerequisites
  create_networking_prereqs   = var.create_networking_prereqs
  virtual_network_name        = "${var.virtual_network_name}-${random_integer.number.result}"
  vnet_address_space          = var.vnet_address_space
  subnet_config               = var.subnet_config
  subnet_config_delegated_aci = var.subnet_config_delegated_aci
  private_dns_zones           = var.private_dns_zones
  resource_subnet_name        = var.resource_subnet_name
  delegated_subnet_name       = var.delegated_subnet_name

  #KeyVault
  kv_config                        = var.kv_config
  keyvault_firewall_default_action = var.keyvault_firewall_default_action
  keyvault_firewall_bypass         = var.keyvault_firewall_bypass
  keyvault_firewall_allowed_ips    = var.keyvault_firewall_allowed_ips

  #Storage Account - File Shares
  sa_config                       = var.sa_config
  shares_config                   = var.shares_config
  storage_firewall_default_action = var.storage_firewall_default_action
  storage_firewall_bypass         = var.storage_firewall_bypass
  storage_firewall_allowed_ips    = var.storage_firewall_allowed_ips

  #msSql Server + Databases
  pass_length        = var.pass_length
  sql_admin_username = var.sql_admin_username
  mssql_config       = var.mssql_config
  mssql_db_config    = var.mssql_db_config
  mssql_fw_rules     = var.mssql_fw_rules

  #SonarQube ACI Container/Group
  aci_group_config             = var.aci_group_config
  sonar_config                 = var.sonar_config
  caddy_config                 = var.caddy_config
  aci_private_dns_record       = var.aci_private_dns_record
  local_dns_zone_name          = var.local_dns_zone_name
  sonarqube_private_dns_record = var.sonarqube_private_dns_record
}