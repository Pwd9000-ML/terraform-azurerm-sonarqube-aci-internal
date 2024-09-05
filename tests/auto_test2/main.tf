terraform {
  backend "azurerm" {}
  #backend "local" {path = "terraform-test2.tfstate"}
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
# MODULE TO TEST                                 #
##################################################
module "sonarcube-aci-internal" {
  source = "../.."

  #Required
  resource_group_name         = azurerm_resource_group.sonarqube_rg.name
  network_resource_group_name = azurerm_resource_group.sonarqube_vnet_rg.name
  location                    = var.location
  tags                        = var.tags

  #Create networking prerequisites
  create_networking_prereqs = true
  virtual_network_name      = "sonarqube-vnet-${random_integer.number.result}"
  vnet_address_space        = ["10.3.0.0/16"]
  subnet_config = [
    {
      subnet_name                                   = "sonarqube-resource-sub-${random_integer.number.result}"
      subnet_address_space                          = ["10.3.0.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
    }
  ]
  subnet_config_delegated_aci = [
    {
      subnet_name                                   = "sonarqube-delegated-sub-${random_integer.number.result}"
      subnet_address_space                          = ["10.3.1.0/24"]
      service_endpoints                             = []
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
      delegation_name                               = "aci-sub-delegation"
      delegation_service                            = "Microsoft.ContainerInstance/containerGroups"
      delegation_ations                             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  ]
  private_dns_zones     = ["privatelink.vaultcore.azure.net", "privatelink.file.core.windows.net", "privatelink.database.windows.net", "pwd9000.local"]
  resource_subnet_name  = "sonarqube-resource-sub-${random_integer.number.result}"
  delegated_subnet_name = "sonarqube-delegated-sub-${random_integer.number.result}"

  #KeyVault
  kv_config = {
    name = "sonarqubekv${random_integer.number.result}"
    sku  = "standard"
  }
  keyvault_firewall_default_action = "Deny"
  keyvault_firewall_bypass         = "AzureServices"
  keyvault_firewall_allowed_ips    = ["0.0.0.0/0"] #for testing purposes only - allow all IPs

  #Storage Account - File Shares
  sa_config = {
    name                     = "sonarqubesa${random_integer.number.result}"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = "TLS1_2"
    access_tier              = "Hot"
    is_hns_enabled           = false
  }
  storage_firewall_default_action = "Deny"
  storage_firewall_bypass         = ["AzureServices"]
  storage_firewall_allowed_ips    = ["0.0.0.0/0"] #for testing purposes only - allow all IPs

  #msSql Server + Databases
  mssql_config = {
    name    = "sonarqubemssql${random_integer.number.result}"
    version = "12.0"
  }

  mssql_db_config = {
    db_name                     = "sonarqubemssqldb${random_integer.number.result}"
    collation                   = "SQL_Latin1_General_CP1_CS_AS"
    create_mode                 = "Default"
    license_type                = null
    max_size_gb                 = 128
    min_capacity                = 1
    auto_pause_delay_in_minutes = 60
    read_scale                  = false
    sku_name                    = "GP_S_Gen5_2"
    storage_account_type        = "Zone"
    zone_redundant              = false
    point_in_time_restore_days  = 7
    backup_interval_in_hours    = 24
  }

  mssql_fw_rules = [["AllowAll", "0.0.0.0", "0.0.0.0"]] #for testing purposes only - allow all IPs

  aci_group_config = {
    container_group_name = "privatesonarqube${random_integer.number.result}"
    ip_address_type      = "Private"
    os_type              = "Linux"
    restart_policy       = "Never"
  }

  sonar_config = {
    container_name                  = "sonarqube-server"
    container_image                 = "ghcr.io/metrostar/quartz/ironbank/big-bang/sonarqube-9:9.9.4-community"
    container_cpu                   = 2
    container_memory                = 8
    container_environment_variables = null
    container_commands              = []
  }

  caddy_config = {
    container_name                  = "caddy-reverse-proxy"
    container_image                 = "ghcr.io/sashkab/docker-caddy2/docker-caddy2:latest"
    container_cpu                   = 1
    container_memory                = 1
    container_environment_variables = null
    container_commands              = ["caddy", "reverse-proxy", "--from", "sonar.pwd9000.local", "--to", "localhost:9000", "--internal-certs"]
  }

  aci_private_dns_record       = true
  local_dns_zone_name          = "pwd9000.local" # (TIP: Add aditional DNS zone links manually to this zone to any peered VNETs for resolution)
  sonarqube_private_dns_record = "sonar"
}